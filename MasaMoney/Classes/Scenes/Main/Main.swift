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
import SideMenu

class Main: UIViewController, UIGestureRecognizerDelegate{
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    //MARKS: Outlets
    
    @IBOutlet weak var incomeCollectionView: UICollectionView!
    
    @IBOutlet weak var outcomeCollectionView: UICollectionView!
    
    @IBOutlet weak var titleBalanceLabel: UILabel!{
        didSet {
            titleBalanceLabel.font = UIFont.mmLatoBoldFont(size: 16)
            titleBalanceLabel.textColor = UIColor.mmGrey
            titleBalanceLabel.text = Strings.balance
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
            titleSpentLabel.text = Strings.spent
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
    var outcomeArray: [Account] = []
    
    var incomeDataSource = AccountDataSource(accountArray: [])
    var outcomeDataSource = AccountDataSource(accountArray: [])
    
    //MARKS: - Views
    override func viewDidLoad() {
        super.viewDidLoad()
        
        incomeDataSource.accountDatasourceDelegate = self
        outcomeDataSource.accountDatasourceDelegate = self
        
        loadData()
        setupCollectionView()
        
        let lpgr : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        lpgr.minimumPressDuration = 0.2
        lpgr.delegate = self
        lpgr.delaysTouchesBegan = true
        self.incomeCollectionView?.addGestureRecognizer(lpgr)
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
    
    //MARKS: - Functions
    
    func setupCollectionView(){
        let nibAccountViewCell = UINib(nibName: "AccountsViewCell", bundle:nil)
        incomeCollectionView.register(nibAccountViewCell, forCellWithReuseIdentifier: "AccountsViewCell")
        outcomeCollectionView.register(nibAccountViewCell, forCellWithReuseIdentifier: "AccountsViewCell")
        
        incomeCollectionView.allowsSelection = true
        incomeCollectionView.dragDelegate = self
        incomeCollectionView.dragInteractionEnabled = true
        incomeCollectionView.dropDelegate = self
        outcomeCollectionView.dropDelegate = self
        
        incomeCollectionView.delegate = incomeDataSource
        incomeCollectionView.dataSource = incomeDataSource
        outcomeCollectionView.delegate = outcomeDataSource
        outcomeCollectionView.dataSource = outcomeDataSource
        
    }
    
    func loadData(){
        //read all the accounts
        let accountsDB = Database.database().reference().child("Accounts").child(MyFirebase.shared.userId)
//        accountsDB.keepSynced(true)
        accountsDB.observe(.value, with: { (snapshot) in
            //go through every result to get the id and read everyone
            if let result = snapshot.children.allObjects as? [DataSnapshot] {
                for child in result {
                    let id = child.key as String
                    accountsDB.child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        let snapshotValue = snapshot.value as? NSDictionary
                        let name = snapshotValue!["name"] as? String
                        let icon = snapshotValue!["icon"] as? String
                        let balance = snapshotValue!["balance"] as? Double
                        let income = snapshotValue!["income"] as? Bool
                        
                        let account = Account()
                        account.id = id
                        account.name = name!
                        account.icon = icon!
                        account.balance = balance!
                        account.income = income!
                        
                        self.setUpAccount(account: account)
                        
                        self.incomeCollectionView.reloadData()
                        self.outcomeCollectionView.reloadData()
                        
                        self.setUpTotal()
                    })
                }
            }
        })
    }
    
    func setUpAccount(account: Account) {
        //Check if the account is an income or outcome and add
        //check if already exists to update it instead of append it
        if account.income == true {
            print(account.name)
            if let i = incomeArray.index(where: {$0.id == account.id}){
                incomeArray[i] = account
                incomeDataSource.accountArray = incomeArray
            }else{
                incomeArray.append(account)
                incomeDataSource.accountArray = incomeArray
            }
        }else{
            if let i = outcomeArray.index(where: {$0.id == account.id}){
                outcomeArray[i] = account
                outcomeDataSource.accountArray = outcomeArray
            }else{
                outcomeArray.append(account)
                outcomeDataSource.accountArray = outcomeArray
            }
        }
    }
    
    func setUpTotal(){
        //Calculate total income and spent and set it
        let sumIncome = incomeArray.map({$0.balance}).reduce(0, +)
        balanceLabel.text = String(format:"%g €",sumIncome)
        let sumSpent = outcomeArray.map({$0.balance}).reduce(0, +)
        spentLabel.text = String(format:"%g €",sumSpent)
    }
    
    // MARK: Actions
    
    @objc func handleLongPress(gestureRecognizer : UILongPressGestureRecognizer){
        
        if (gestureRecognizer.state != UIGestureRecognizerState.ended){
            return
        }
        
        let location = gestureRecognizer.location(in: self.incomeCollectionView)
        
        guard let index = (self.incomeCollectionView?.indexPathForItem(at: location)) else {return}
        
        let vc: AddAccountVC = UIStoryboard(.Main).instantiateViewController()
        vc.vcType = .edit
        vc.account = incomeDataSource.accountArray[index.row]
        self.navigationItem.title = Strings.back
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func addIncomeButton(_ sender: Any) {
        let vc: AddIncome = UIStoryboard(.AddIncome).instantiateViewController()
        vc.incomeArray = incomeArray
        self.navigationItem.title = Strings.back
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func addInAccount(_ sender: Any) {
        let vc: AddAccountVC = UIStoryboard(.Main).instantiateViewController()
        vc.vcType = .income
        self.navigationItem.title = Strings.back
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func addOutAccount(_ sender: Any) {
        let vc: AddAccountVC = UIStoryboard(.Main).instantiateViewController()
        vc.vcType = .outcome
        self.navigationItem.title = Strings.back
        self.navigationController?.pushViewController(vc, animated: true)
    }    
    
}

extension Main: AccountDataSourceOutput  {
    func didSelectAccountAtIndexPath(_ indexPath: IndexPath, tag: Int ) {
        //Identify collectionView by tag
        //Open movement history and send the account chosen
        //set the string to the navigation item
        if tag == 1 {
            let vc: MovementVC = UIStoryboard(.Main).instantiateViewController()
            vc.account = incomeDataSource.accountArray[indexPath.row]
            self.navigationItem.title = Strings.back
            self.navigationController?.pushViewController(vc, animated: true)
        } else if tag == 2 {
            let vc: MovementVC = UIStoryboard(.Main).instantiateViewController()
            vc.account = outcomeDataSource.accountArray[indexPath.row]
            self.navigationItem.title = Strings.back
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension Main: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let account = incomeDataSource.accountArray[indexPath.row]
        let accountProvider = NSItemProvider(object: account)
        let dragAccount = UIDragItem(itemProvider: accountProvider)
        dragAccount.localObject = account
        return [dragAccount]
    }
}

extension Main: UICollectionViewDropDelegate{
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        //Get destination account
        guard let destinationIndex = coordinator.destinationIndexPath?.row else {return}
        let destinationAccount = outcomeArray[destinationIndex]
        
        //Get origin account
        for item in coordinator.items {
            item.dragItem.itemProvider.loadObject(ofClass: Account.self, completionHandler: { (account, error) in
                if let originAccount = account as? Account {
                    //Send accounts and open calculator
                    DispatchQueue.main.async {
                        let vc: IncomeCalculator = UIStoryboard(.AddIncome).instantiateViewController()
                        vc.accountOrigin = originAccount
                        vc.accountDestination = destinationAccount
                        self.navigationItem.title = Strings.back
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            })
        }
    }
}
