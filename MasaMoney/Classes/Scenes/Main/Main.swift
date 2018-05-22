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
        
        outcomeCollectionView.delegate = outcomeDataSource
        outcomeCollectionView.dataSource = outcomeDataSource
        outcomeDataSource.outcomeDatasourceDelegate = self
        
//        outcomeCollectionView.dragDelegate = self
//        outcomeCollectionView.dropDelegate = self
        outcomeCollectionView.dragInteractionEnabled = true
        
        incomeCollectionView.delegate = incomeDataSource
        incomeCollectionView.dataSource = incomeDataSource
        incomeDataSource.incomeDatasourceDelegate = self
//        incomeCollectionView.dragDelegate = self
//        incomeCollectionView.dropDelegate = self
        incomeCollectionView.dragInteractionEnabled = true
        
        
        
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
                        
                        var account = Account()
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
    func didSelectAccountAtIndexPath(_ indexPath: IndexPath) {
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

//extension Main: UICollectionViewDragDelegate, UICollectionViewDropDelegate {
//    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
//
//    }
//
//
//}
