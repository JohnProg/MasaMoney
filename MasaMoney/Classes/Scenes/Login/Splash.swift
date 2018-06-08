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
        
        Router.openMainApp()
    }

}

