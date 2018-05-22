//
//  Movement.swift
//  MasaMoney
//
//  Created by Maria Lopez on 20/05/2018.
//  Copyright © 2018 Maria Lopez. All rights reserved.
//

import UIKit
import Firebase

class MovementVC: UIViewController {
    @IBOutlet weak var totalLabel: UILabel!{
        didSet {
            totalLabel.font = UIFont.mmLatoSemiBoldFont(size: 18)
            totalLabel.textColor = UIColor.mmBlackish
        }
    }
    @IBOutlet weak var movTableView: UITableView!
    
    // MARK: -Properties
    var account = Account()
    var movementArray: [Movement] = []
    var movementDataSource = MovementDataSource(movementArray: [])

    override func viewDidLoad() {
        super.viewDidLoad()
        totalLabel.text = account.name
        setupTableView()
        loadData()
    }
    
    func setupTableView(){
        let nibMovementViewCell = UINib(nibName: "MovementCell", bundle:nil)
        movTableView.register(nibMovementViewCell, forCellReuseIdentifier: "MovementCell")
        
        movTableView.delegate = movementDataSource
        movTableView.dataSource = movementDataSource
        
    }
    
    // -TODO: Controlar si no hay historico
    func loadData(){
        
        let movementsDB = Database.database().reference().child("Movements").child(MyFirebase.shared.userId)
        
        movementsDB.observe(.value, with: { (snapshot) in
            
            if let result = snapshot.children.allObjects as? [DataSnapshot] {
                for child in result {
                    let id = child.key as String
                    movementsDB.child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        let snapshotValue = snapshot.value as? NSDictionary
                        
                        let origin = snapshotValue!["origin"] as? String
                        let destination = snapshotValue!["destination"] as? String
                        let amount = snapshotValue!["amount"] as? Double
                        let date = snapshotValue!["date"] as? String
                        
                        
                        var movement = Movement()
                        movement.origin = origin!
                        movement.destination = destination!
                        movement.amount = amount!
                        movement.date = date!
                        
                        movementsDB.child(id).child("Accounts").observeSingleEvent(of: .value, with: { (snapshot) in
                            let snapshotValue = snapshot.value as? NSDictionary
                            
                            let historic = snapshotValue![self.account.id] as? Bool
                            
                            if historic == true {
                                print("Esta dentro : " + self.account.id)
                                self.movementArray.append(movement)
                                print(self.movementArray)
                                self.movementDataSource.movementArray = self.movementArray
                                self.movTableView.reloadData()
                            }
                        })
                    })
                }
            }
        })
    }

}


