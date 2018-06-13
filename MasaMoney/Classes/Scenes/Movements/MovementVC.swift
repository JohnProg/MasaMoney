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
    
    // MARK: - Outlets
    
    @IBOutlet weak var totalLabel: UILabel!{
        didSet {
            totalLabel.font = UIFont.mmLatoSemiBoldFont(size: 18)
            totalLabel.textColor = UIColor.mmBlackish
            totalLabel.text = String(format:"%g €",account.balance)
        }
    }
    
    @IBOutlet weak var movTableView: UITableView!
    
    // MARK: -Properties
    
    //Account received from main
    var account = Account()
    var movementArray: [Movement] = []
    //lazy -> it's initializad just when is called
    lazy var movementDataSource = MovementDataSource(movementArray: [], delegate: self)

    // MARK: -View
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationItem.title = account.name
        setupTableView()
        loadData()
    }
    
    // MARK: -Functions
    func setupTableView(){
        let nibMovementViewCell = UINib(nibName: "MovementCell", bundle:nil)
        movTableView.register(nibMovementViewCell, forCellReuseIdentifier: "MovementCell")
        
        movTableView.delegate = movementDataSource
        movTableView.dataSource = movementDataSource
        
    }
    
    func loadData(){
        MyFirebase.shared.loadMovements(account: account) { (movements, error) in
            if let error = error {
                //error
                Service.dismissHud(self.hud, text: Strings.errorSignUp, detailText: error.localizedDescription, delay: 3)
            }
            
            if let movements = movements {
                //something
                self.movementDataSource.movementArray = movements
                self.movementDataSource.titleAccount = self.account.name
                self.movTableView.reloadData()
            }
        }
    }
}

extension MovementVC : MovementDataSourceDelegate {
    // MARK: - MovementDataSourceDelegate
    func didSelectImage(with url: String) {
        let vc: PictureVC = UIStoryboard(.Picture).instantiateViewController()
        vc.picture = url
        vc.modalPresentationStyle = .formSheet
        present(vc, animated: true, completion: nil)
    }
}
