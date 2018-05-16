//
//  SplashViewController.swift
//  MasaMoney
//
//  Created by Maria Lopez on 16/04/2018.
//  Copyright © 2018 Maria Lopez. All rights reserved.
//

import UIKit

class Splash: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check for a CURRENT LOGIN TOKEN
        MyFirebase.shared.addUserListener(loggedIn: false, completion: { isLogedIn in
            if let isLogedIn = isLogedIn, isLogedIn {
//                let vc = Main.storyboardInstance()
//                self.present(vc, animated: true, completion: nil)
                let vc: Main = UIStoryboard(.Main).instantiateViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = Login.storyboardInstance()
                self.present(vc, animated: true, completion: nil)
            }
        })
    }

}

