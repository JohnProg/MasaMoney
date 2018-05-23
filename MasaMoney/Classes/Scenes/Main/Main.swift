//
//  MainViewController.swift
//  MasaMoney
//
//  Created by Maria Lopez on 16/04/2018.
//  Copyright © 2018 Maria Lopez. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import LBTAComponents
import JGProgressHUD
import GoogleSignIn

class Main: UIViewController{
    // TODO: - Remove imports not used
    //MARKS: Outlets
    
    @IBOutlet weak var incomeCollectionView: UICollectionView!
    
    @IBOutlet weak var outcomeCollectionView: UICollectionView!
    
    @IBOutlet weak var titleBalanceLabel: UILabel!{
        didSet {
            titleBalanceLabel.font = UIFont.mmLatoBoldFont(size: 16)
            titleBalanceLabel.textColor = UIColor.mmGrey
        }
    }
    @IBOutlet weak var balanceLabel: UILabel!{
        didSet {
            balanceLabel.font = UIFont.mmLatoBoldFont(size: 14)
            balanceLabel.textColor = UIColor.mmGrey
        }
    }
    
    @IBOutlet weak var titleSpentLabel: UILabel!{
        didSet {
            titleSpentLabel.font = UIFont.mmLatoBoldFont(size: 16)
            titleSpentLabel.textColor = UIColor.mmGrey
        }
    }
    @IBOutlet weak var spentLabel: UILabel!{
        didSet {
            spentLabel.font = UIFont.mmLatoBoldFont(size: 14)
            spentLabel.textColor = UIColor.mmGrey
        }
    }
    @IBOutlet weak var summarySeparator: UIView!{
        didSet {
            summarySeparator.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        }
    }
    
    //MARKS: Properties
    
    var incomeArray: [Account] = []
    var incomeDataSource = IncomeDataSource(incomeArray: [])
    var outcomeArray: [Account] = []
    var outcomeDataSource = OutcomeDataSource(outcomeArray: [])
    
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    
    
    //MARKS: Views
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setupCollectionView(){
        let nibAccountViewCell = UINib(nibName: "AccountsViewCell", bundle:nil)
        incomeCollectionView.register(nibAccountViewCell, forCellWithReuseIdentifier: "AccountsViewCell")
        outcomeCollectionView.register(nibAccountViewCell, forCellWithReuseIdentifier: "AccountsViewCell")
        
        incomeCollectionView.allowsSelection = true
        incomeCollectionView.delegate = incomeDataSource
        incomeCollectionView.dataSource = incomeDataSource
        incomeCollectionView.dragDelegate = self
        incomeCollectionView.dragInteractionEnabled = true
        
        outcomeCollectionView.delegate = outcomeDataSource
        outcomeCollectionView.dataSource = outcomeDataSource
        outcomeCollectionView.dropDelegate = self
        
        incomeDataSource.incomeDatasourceDelegate = self
        outcomeDataSource.outcomeDatasourceDelegate = self
        
    }
    
    func loadData(){
        
        let accountsDB = Database.database().reference().child("Accounts").child(MyFirebase.shared.userId)
        accountsDB.observe(.value, with: { (snapshot) in
            
            if let result = snapshot.children.allObjects as? [DataSnapshot] {
                for child in result {
                    let id = child.key as String
                    accountsDB.child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        let snapshotValue = snapshot.value as? NSDictionary
                        let name = snapshotValue!["name"] as? String
                        let balance = snapshotValue!["balance"] as? Double
                        let income = snapshotValue!["income"] as? Bool
                        
                        let account = Account()
                        account.id = id
                        account.name = name!
                        account.balance = balance!
                        account.income = income!
                        
                        if account.income == true {
                            if let i = self.incomeArray.index(where: {$0.id == account.id}){
                                self.incomeArray[i] = account
                                self.incomeDataSource.incomeArray = self.incomeArray
                            }else{
                                self.incomeArray.append(account)
                                self.incomeDataSource.incomeArray = self.incomeArray
                            }
                        }else{
                            if let i = self.outcomeArray.index(where: {$0.id == account.id}){
                                self.outcomeArray[i] = account
                                self.outcomeDataSource.outcomeArray = self.outcomeArray
                            }else{
                                self.outcomeArray.append(account)
                                self.outcomeDataSource.outcomeArray = self.outcomeArray
                            }
                        }
                        
                        self.incomeCollectionView.reloadData()
                        self.outcomeCollectionView.reloadData()
                        
                        //Calculate total income and spent and set it
                        let sumIncome = self.incomeArray.map({$0.balance}).reduce(0, +)
                        self.balanceLabel.text = String(format:"%g €",sumIncome)
                        let sumSpent = self.outcomeArray.map({$0.balance}).reduce(0, +)
                        self.spentLabel.text = String(format:"%g €",sumSpent)
                        
                    })
                }
            }
        })
    }
    
    // MARK: Actions
    
    @IBAction func logOutButton(_ sender: Any) {
        try! Auth.auth().signOut()
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let loginStoryboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let loginController = loginStoryboard.instantiateViewController(withIdentifier: "Login") as! Login
        let nav = UINavigationController(rootViewController: loginController)
        appdelegate.window!.rootViewController = nav
    }
    
    @IBAction func addIncomeButton(_ sender: Any) {
        let vc: AddIncome = UIStoryboard(.AddIncome).instantiateViewController()
        vc.incomeArray = incomeArray
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension Main: IncomeDataSourceOutput{
    func didSelectIncomeAccountAtIndexPath(_ indexPath: IndexPath) {
        let vc: MovementVC = UIStoryboard(.Main).instantiateViewController()
        vc.account = incomeDataSource.incomeArray[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension Main: OutcomeDataSourceOutput  {
    func didSelectOutcomeAccountAtIndexPath(_ indexPath: IndexPath) {
        let vc: MovementVC = UIStoryboard(.Main).instantiateViewController()
        vc.account = outcomeDataSource.outcomeArray[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension Main: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let account = incomeDataSource.incomeArray[indexPath.row]
        let accountProvider = NSItemProvider(object: account)
        let dragAccount = UIDragItem(itemProvider: accountProvider)
        dragAccount.localObject = account
        return [dragAccount]
    }
}

extension Main: UICollectionViewDropDelegate{
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        //Get outcome account
        let destinationIndex = coordinator.destinationIndexPath?.row
        let destinationAccount = outcomeArray[destinationIndex!]
        
        for item in coordinator.items {
            item.dragItem.itemProvider.loadObject(ofClass: Account.self, completionHandler: { (account, error) in
                if let originAccount = account as? Account {
                    //Send accounts and open calculator
                    DispatchQueue.main.async {
                        let vc: IncomeCalculator = UIStoryboard(.AddIncome).instantiateViewController()
                        vc.accountOrigin = originAccount
                        vc.accountDestination = destinationAccount
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            })
        }
    }
}
