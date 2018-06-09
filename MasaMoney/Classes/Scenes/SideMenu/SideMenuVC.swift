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

    @IBOutlet weak var atmTitle: UILabel!{
        didSet{
            atmTitle.text = Strings.atm
        }
    }
    @IBOutlet weak var profileTitle: UILabel!{
        didSet{
            profileTitle.text = Strings.perfil
        }
    }
    @IBOutlet weak var logoutTitle: UILabel!{
        didSet{
            logoutTitle.text = Strings.logout
        }
    }
    
    @IBOutlet weak var contactTitle: UILabel!{
        didSet{
            contactTitle.text = Strings.contact
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView.cellForRow(at: indexPath)?.tag{
        //Map
        case 1:
            let vc: MapVC = UIStoryboard(.Main).instantiateViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        //Profile
        case 2:
            let vc: ProfileVC = UIStoryboard(.Main).instantiateViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        //Contact
        case 3:
            let email = "contact@masamoney.com"
            let url = URL(string: "mailto:\(email)")
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
       //Log out
        case 4:
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
