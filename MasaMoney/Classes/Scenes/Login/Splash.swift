//
//  SplashViewController.swift
//  MasaMoney
//
//  Created by Maria Lopez on 16/04/2018.
//  Copyright © 2018 Maria Lopez. All rights reserved.
//

import UIKit
import JGProgressHUD

class Splash: UIViewController {
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check for a CURRENT LOGIN TOKEN
        MyFirebase.shared.addUserListener(loggedIn: false, completion: { isLogedIn in
            if let isLogedIn = isLogedIn, isLogedIn {
                self.hud.textLabel.text = "Loading data..."
                self.hud.show(in: self.view, animated: true)
                
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

