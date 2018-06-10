//
//  Movement.swift
//  MasaMoney
//
//  Created by Maria Lopez on 20/05/2018.
//  Copyright © 2018 Maria Lopez. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class MovementVC: UIViewController {
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    
    @IBOutlet weak var totalLabel: UILabel!{
        didSet {
            totalLabel.font = UIFont.mmLatoSemiBoldFont(size: 18)
            totalLabel.textColor = UIColor.mmBlackish
            totalLabel.text = String(format:"%g €",account.balance)
        }
    }
    @IBOutlet weak var movTableView: UITableView!
    
    // MARK: -Properties
    var account = Account()
    var movementArray: [Movement] = []
    var movementDataSource = MovementDataSource(movementArray: [])

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = account.name
        setupTableView()
        loadData()
    }
    
    func setupTableView(){
        let nibMovementViewCell = UINib(nibName: "MovementCell", bundle:nil)
        movTableView.register(nibMovementViewCell, forCellReuseIdentifier: "MovementCell")
        
        movTableView.delegate = movementDataSource
        movTableView.dataSource = movementDataSource
        
    }
    
    func loadData(){
        
        //check every movement
        
        let movementsDB = Database.database().reference().child("Movements").child(MyFirebase.shared.userId)
        hud.textLabel.text = Strings.loading
        hud.show(in: self.view, animated: false)
        movementsDB.keepSynced(true)
        movementsDB.observe(.value, with: { (snapshot) in
            
            if let result = snapshot.children.allObjects as? [DataSnapshot] {
                for child in result {
                    let id = child.key as String
                    movementsDB.child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        let snapshotValue = snapshot.value as? NSDictionary
                        
                        let origin = snapshotValue!["origin"] as? String
                        let destination = snapshotValue!["destination"] as? String
                        let comment = snapshotValue!["comment"] as? String
                        let amount = snapshotValue!["amount"] as? Double
                        let date = snapshotValue!["date"] as? String
                        
                        
                        var movement = Movement()
                        movement.origin = origin!
                        movement.destination = destination!
                        movement.comment = comment!
                        movement.amount = amount!
                        movement.date = date!
                        
                        //check if the account is in the movement, if so, add it to the array to show
                        movementsDB.child(id).child("Accounts").observeSingleEvent(of: .value, with: { (snapshot) in
                            let snapshotValue = snapshot.value as? NSDictionary
                            
                            let historic = snapshotValue![self.account.id] as? Bool
                            
                            if historic == true {
                                self.movementArray.append(movement)
                                self.movementDataSource.movementArray = self.movementArray
                                self.movTableView.reloadData()
                            }
                        })
                    })
                }
            }
        })
        hud.dismiss()
    }
}


