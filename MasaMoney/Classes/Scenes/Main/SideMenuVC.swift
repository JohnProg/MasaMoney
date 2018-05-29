//
//  SideMenuVC.swift
//  MasaMoney
//
//  Created by Maria Lopez on 28/05/2018.
//  Copyright © 2018 Maria Lopez. All rights reserved.
//

import UIKit
import Firebase

class SideMenuVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(SideMenuVC.tapFunction))
        logOutLabel.addGestureRecognizer(tap)
    }

    @IBOutlet weak var atmLabel: UILabel!
    
    @IBOutlet weak var logOutLabel: UILabel!
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        try! Auth.auth().signOut()
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let loginStoryboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let loginController = loginStoryboard.instantiateViewController(withIdentifier: "Login") as! Login
        let nav = UINavigationController(rootViewController: loginController)
        appdelegate.window!.rootViewController = nav
    }
}
