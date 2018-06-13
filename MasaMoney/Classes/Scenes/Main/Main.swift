//
//  MainViewController.swift
//  MasaMoney
//
//  Created by Maria Lopez on 16/04/2018.
//  Copyright © 2018 Maria Lopez. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD
import SideMenu

class Main: UIViewController, UIGestureRecognizerDelegate{
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    //MARK: - Outlets
    
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
    
    //MARK: - Properties
    
    var incomeArray: [Account] = []
    var outcomeArray: [Account] = []
    
    var incomeDataSource = AccountDataSource(accountArray: [])
    var outcomeDataSource = AccountDataSource(accountArray: [])
    
    //MARK: - Views
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.mmBlackish
        
        incomeDataSource.accountDatasourceDelegate = self
        outcomeDataSource.accountDatasourceDelegate = self
        
        loadData()
        setupCollectionView()
        
        ///set the recognize in multiple views
        incomeCollectionView.addGestureRecognizer(setGestureRecognizer())
        outcomeCollectionView.addGestureRecognizer(setGestureRecognizer())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Refresh data
        incomeArray.removeAll()
        outcomeArray.removeAll()
        loadData()
        incomeCollectionView.reloadData()
        outcomeCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //MARK: - Functions
    
    func setupCollectionView(){
        let nibAccountViewCell = UINib(nibName: "AccountsViewCell", bundle:nil)
        incomeCollectionView.register(nibAccountViewCell, forCellWithReuseIdentifier: "AccountsViewCell")
        outcomeCollectionView.register(nibAccountViewCell, forCellWithReuseIdentifier: "AccountsViewCell")
        
        incomeCollectionView.delegate = incomeDataSource
        incomeCollectionView.dataSource = incomeDataSource
        incomeCollectionView.dropDelegate = incomeDataSource
        incomeCollectionView.dragDelegate = incomeDataSource
        incomeCollectionView.allowsSelection = true
        incomeCollectionView.dragInteractionEnabled = true
        
        outcomeCollectionView.delegate = outcomeDataSource
        outcomeCollectionView.dataSource = outcomeDataSource
        outcomeCollectionView.dropDelegate = outcomeDataSource
        
    }
    
    func loadData(){
        
        //read all the accounts
        let accountsDB = Database.database().reference().child("Accounts").child(MyFirebase.shared.userId)
        hud.textLabel.text = Strings.loading
        hud.show(in: self.view, animated: false)
        accountsDB.keepSynced(true)
        accountsDB.observe(.value, with: { (snapshot) in
            //go through every result to get the id and read everyone
            if let result = snapshot.children.allObjects as? [DataSnapshot] {
                for child in result {
                    let id = child.key as String
                    accountsDB.child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        let snapshotValue = snapshot.value as? NSDictionary
                        guard let name = snapshotValue!["name"] as? String else {return}
                        guard let icon = snapshotValue!["icon"] as? String else {return}
                        guard let balance = snapshotValue!["balance"] as? Double else {return}
                        guard let income = snapshotValue!["income"] as? Bool else {return}
                        
                        let account = Account()
                        account.id = id
                        account.name = name
                        account.icon = icon
                        account.balance = balance
                        account.income = income
                        
                        self.setUpAccount(account: account)
                        
                        self.incomeCollectionView.reloadData()
                        self.outcomeCollectionView.reloadData()
                        
                        self.setUpTotal()
                    })
                }
            }
        })
        hud.dismiss()
    }
    
    func setUpAccount(account: Account) {
        //Check if the account is an income or outcome and add
        //check if already exists to update it instead of append it
        if account.income == true {
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
    
    func setGestureRecognizer() -> UILongPressGestureRecognizer {
        var longRecognizer = UILongPressGestureRecognizer()
        longRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longRecognizer.minimumPressDuration = 0.2
        longRecognizer.delegate = self
        longRecognizer.delaysTouchesBegan = true
        return longRecognizer
    }
    
    // MARK: Actions
    
    @objc func handleLongPress(gestureRecognizer : UILongPressGestureRecognizer){
        var account = Account()
        if (gestureRecognizer.state != UIGestureRecognizerState.ended){
            return
        }
        // Check from where is coming the long press, pick the account and open the next scene
        if gestureRecognizer.view == incomeCollectionView {
            let locationIn = gestureRecognizer.location(in: self.incomeCollectionView)
            if let indexIn = (self.incomeCollectionView?.indexPathForItem(at: locationIn)) {
                account = incomeDataSource.accountArray[indexIn.row]
            }
        } else {
            let locationOut = gestureRecognizer.location(in: self.outcomeCollectionView)
            if let indexOut = (self.outcomeCollectionView?.indexPathForItem(at: locationOut)) {
                account = outcomeDataSource.accountArray[indexOut.row]
            }
        }
        
        if account.name != ""{
            let vc: AccountVC = UIStoryboard(.Main).instantiateViewController()
            vc.vcType = .edit
            vc.account = account
            self.navigationItem.title = Strings.back
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func addIncomeButton(_ sender: Any) {
        let vc: AddIncome = UIStoryboard(.AddIncome).instantiateViewController()
        vc.incomeArray = incomeArray
        self.navigationItem.title = Strings.back
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func addInAccount(_ sender: Any) {
        let vc: AccountVC = UIStoryboard(.Main).instantiateViewController()
        vc.vcType = .income
        self.navigationItem.title = Strings.back
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func addOutAccount(_ sender: Any) {
        let vc: AccountVC = UIStoryboard(.Main).instantiateViewController()
        vc.vcType = .outcome
        self.navigationItem.title = Strings.back
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension Main: AccountDataSourceDelegate  {
    // DRAG
    func drag(_ indexPath: IndexPath) -> [UIDragItem] {
        //get the account from the array
        let provider = NSItemProvider(object: incomeDataSource.accountArray[indexPath.row])
        let dragItem = UIDragItem(itemProvider: provider)
        dragItem.previewProvider = {
            let image = UIImage(named: "dollar")
            let imageView = UIImageView(image: image!)
            let dollar = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 64, height: 64))
            dollar.layer.cornerRadius = dollar.frame.size.width/2
            dollar.clipsToBounds = true
            dollar.addSubview(imageView)
            return UIDragPreview(view: dollar)
        }
        return [dragItem]
    }
    // DROP
    func performDropWith(_ coordinator: UICollectionViewDropCoordinator, tag: Int) {
        //Get destination account
        guard let destinationIndex = coordinator.destinationIndexPath?.row else {return}
        var destinationAccount = Account()
        if tag == 1 {
            destinationAccount = incomeArray[destinationIndex]
        } else if tag == 2 {
            destinationAccount = outcomeArray[destinationIndex]
        }
        //Get origin account
        for item in coordinator.items {
            item.dragItem.itemProvider.loadObject(ofClass: Account.self, completionHandler: { (account, error) in
                if let originAccount = account as? Account {
                    //Send accounts and open calculator
                    DispatchQueue.main.async {
                        let vc: CalculatorVC = UIStoryboard(.AddIncome).instantiateViewController()
                        vc.accountOrigin = originAccount
                        vc.accountDestination = destinationAccount
                        self.navigationItem.title = Strings.back
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            })
        }
    }
    
    func canHandle() -> Bool {
        return true
    }
    
    func dropSessionDidUpdate() -> UICollectionViewDropProposal {
        let proposal = UICollectionViewDropProposal(operation: .copy, intent: .insertIntoDestinationIndexPath)
        return proposal

    }
    // SELECT ITEM
    func didSelectAccountAtIndexPath(_ indexPath: IndexPath, tag: Int ) {
        //Identify collectionView by tag
        //Open movementVC and send the account chosen
        //set the string to the navigation item
        let vc: MovementVC = UIStoryboard(.Main).instantiateViewController()
        if tag == 1 {
            vc.account = incomeDataSource.accountArray[indexPath.row]
        } else if tag == 2 {
            vc.account = outcomeDataSource.accountArray[indexPath.row]
        }
        self.navigationItem.title = Strings.back
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
