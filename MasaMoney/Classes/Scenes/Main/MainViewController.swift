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
    
    //MARKS: Properties
//    var accountsDataSource = AccountsDataSource(accounts: [])
    var accountsArray: [Account] = []
    
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
        collectionView.isScrollEnabled = true
        
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

                        print(account)
                        self.accountsArray.append(account)
                        self.collectionView.reloadData()
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
        return accountsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AccountsViewCell", for: indexPath) as? AccountsViewCell
            else {
                return UICollectionViewCell()
        }
        cell.configure(account: accountsArray[indexPath.item])
        
        return cell
    }
}
