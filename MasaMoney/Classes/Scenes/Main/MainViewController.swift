//
//  MainViewController.swift
//  MasaMoney
//
//  Created by Maria Lopez on 16/04/2018.
//  Copyright © 2018 Maria Lopez. All rights reserved.
//

import UIKit
import FirebaseAuth

class MainViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple
        checkLoggedInUserStatus()
    }
    
    func checkLoggedInUserStatus(){
        if Auth.auth().currentUser == nil{
            DispatchQueue.main.async {
                let logInController = LogInViewController()
                let loginNavigationController = UINavigationController(rootViewController: logInController)
                self.present(loginNavigationController, animated: false, completion: nil)
                return
            }
        }
    }
    
    
}
