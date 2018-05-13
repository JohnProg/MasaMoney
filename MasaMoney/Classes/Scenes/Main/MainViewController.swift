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
    
    @IBOutlet weak var collectionView: UICollectionView!
    
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
    var array: [Account] = []
//    var badgesDataSource = ProgressBadgesDataSource(badges: [])
    var outcomeArray = OutcomeDataSource(outcomeArray: [])
    
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
        collectionView.register(nibAccountViewCell, forCellWithReuseIdentifier: "AccountsViewCell")
        outcomeCollectionView.register(nibAccountViewCell, forCellWithReuseIdentifier: "AccountsViewCell")
        
        outcomeCollectionView.delegate = outcomeArray
        outcomeCollectionView.dataSource = outcomeArray
        
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
                        }else{
                            self.array.append(account)
                            self.outcomeArray.outcomeArray = self.array
                        }
                        
                        self.collectionView.reloadData()
                        self.outcomeCollectionView.reloadData()
                        print("reloadData")
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
    
}

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return incomeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AccountsViewCell", for: indexPath) as? AccountsViewCell
            else {
                return UICollectionViewCell()
        }
        cell.configure(account: incomeArray[indexPath.item])
        
        return cell
    }
}
