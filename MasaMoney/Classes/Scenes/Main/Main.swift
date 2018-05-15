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

class MainViewController: UIViewController{
    
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
    
    func setupCollectionView(){
        let nibAccountViewCell = UINib(nibName: "AccountsViewCell", bundle:nil)
        incomeCollectionView.register(nibAccountViewCell, forCellWithReuseIdentifier: "AccountsViewCell")
        outcomeCollectionView.register(nibAccountViewCell, forCellWithReuseIdentifier: "AccountsViewCell")
        
        outcomeCollectionView.delegate = outcomeDataSource
        outcomeCollectionView.dataSource = outcomeDataSource
        
        incomeCollectionView.delegate = incomeDataSource
        incomeCollectionView.dataSource = incomeDataSource
        
    }
    
    func loadData(){
        
        let accountsDB = Database.database().reference().child("Accounts").child(MyFirebase.shared.userId)

        accountsDB.observeSingleEvent(of: .value, with: { (snapshot) in

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
                            self.incomeArray.append(account)
                            self.incomeDataSource.incomeArray = self.incomeArray
                        }else{
                            self.outcomeArray.append(account)
                            self.outcomeDataSource.outcomeArray = self.outcomeArray
                        }
                        
                        self.incomeCollectionView.reloadData()
                        self.outcomeCollectionView.reloadData()
                    })
                    
                }
            }
        })
    }
    
    static func storyboardInstance() -> MainViewController {
        let storyboard = UIStoryboard(name: "MainViewController", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
    }
    
    // MARK: Actions
    
    @IBAction func logOutButton(_ sender: Any) {
        try! Auth.auth().signOut()
        let vc = LogInViewController.storyboardInstance()
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func addIncomeButton(_ sender: Any) {
        let vc: AddIncomeViewController = UIStoryboard(.AddIncomeViewController).instantiateViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
