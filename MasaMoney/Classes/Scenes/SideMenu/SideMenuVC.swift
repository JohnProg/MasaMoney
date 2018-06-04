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
    }

    @IBOutlet weak var atmLabel: UILabel!
    
    
    @IBOutlet weak var logOutLabel: UILabel!

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView.cellForRow(at: indexPath)?.tag{
        case 1:
            let vc: MapVC = UIStoryboard(.Main).instantiateViewController()
            self.navigationController?.pushViewController(vc, animated: true)

        case 2:
            print("tag 2 tapped")
        case 3:
            try! Auth.auth().signOut()
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            let loginStoryboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
            let loginController = loginStoryboard.instantiateViewController(withIdentifier: "Login") as! Login
            let nav = UINavigationController(rootViewController: loginController)
            appdelegate.window!.rootViewController = nav
        case .none:
            print("tag none")
        case .some(_):
            print("some")
        }
    }
    
}
