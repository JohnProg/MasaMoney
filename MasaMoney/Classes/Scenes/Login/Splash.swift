//
//  SplashViewController.swift
//  MasaMoney
//
//  Created by Maria Lopez on 16/04/2018.
//  Copyright © 2018 Maria Lopez. All rights reserved.
//

import UIKit

class Splash: UIViewController {
    
    @IBOutlet weak var splashLabel: UILabel!{
        didSet{
            splashLabel.text = Strings.splashWelcome
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openMainApp()
    }
    
    func openMainApp(){
        // Check for a CURRENT LOGIN TOKEN
        MyFirebase.shared.addUserListener(loggedIn: false, completion: { isLogedIn in
            if let isLogedIn = isLogedIn, isLogedIn {
                let appdelegate = UIApplication.shared.delegate as! AppDelegate
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let mainController = mainStoryboard.instantiateViewController(withIdentifier: "Main") as! Main
                let nav = UINavigationController(rootViewController: mainController)
                appdelegate.window!.rootViewController = nav
                
            } else {
                
                let appdelegate = UIApplication.shared.delegate as! AppDelegate
                let loginStoryboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
                let loginController = loginStoryboard.instantiateViewController(withIdentifier: "Login") as! Login
                let nav = UINavigationController(rootViewController: loginController)
                appdelegate.window!.rootViewController = nav
            }
        })
    }
}

