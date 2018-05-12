//
//  ViewController.swift
//  MasaMoney
//
//  Created by Maria Lopez on 16/04/2018.
//  Copyright © 2018 Maria Lopez. All rights reserved.
//

import UIKit
import LBTAComponents
import JGProgressHUD
import SwiftyJSON
import FirebaseAuth
import FacebookCore
import FacebookLogin
import FirebaseStorage
import FirebaseDatabase

class LogInViewController: UIViewController{
    
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    
    var name: String? = ""
    var email: String? = ""
    var profileImage: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    
    //MARK: - Actions Buttons
    
    @IBAction func facebookButton(_ sender: Any) {
        hud.textLabel.text = "Logging in with Facebook..."
        hud.show(in: view, animated: true)
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: self) { (result) in
            switch result {
            case .success(grantedPermissions: _, declinedPermissions: _, token: _):
                print("Succesfully logged in into Facebook.")
                self.signIntoFirebaseWithFacebook()
                
            case .failed(let err):
                Service.dismissHud(self.hud, text: "Error", detailText: "Failed to get Facebook user with error: \(err)", delay: 3)
            case .cancelled:
                Service.dismissHud(self.hud, text: "Error", detailText: "Canceled getting Facebook user.", delay: 3)
            }
        }
    }
    

    //MARK: - Sign into firebase
    
    func signIntoFirebaseWithFacebook() {
        guard let authenticationToken = AccessToken.current?.authenticationToken else { return }
        let credential = FacebookAuthProvider.credential(withAccessToken: authenticationToken)
        Auth.auth().signInAndRetrieveData(with: credential) { (user, err) in
            if let err = err {
                print(err)
                Service.dismissHud(self.hud, text: "Sign up error", detailText: err.localizedDescription, delay: 3)
                return
            }
            print("Succesfully authenticated with Firebase.")
            if(user?.additionalUserInfo?.isNewUser == true) {
                MyFirebase.shared.createBasicAccounts()
            }
            self.fetchFacebookUser()
        }
    }
    
    //MARK: - Fetch Facebook user
    
    func fetchFacebookUser() {
        
        let graphRequestConnection = GraphRequestConnection()
        let graphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "id, email, name, picture.type(large)"], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: .defaultVersion)
        
        graphRequestConnection.add(graphRequest, completion: { (httpResponse, result) in
            switch result {
            case .success(response: let response):
                
                guard let responseDict = response.dictionaryValue else { Service.dismissHud(self.hud, text: "Error", detailText: "Failed to fetch user.", delay: 3); return }
                let json = JSON(responseDict)
                self.name = json["name"].string
                self.email = json["email"].string
                guard let profilePictureUrl = json["picture"]["data"]["url"].string else { Service.dismissHud(self.hud, text: "Error", detailText: "Failed to fetch user.", delay: 3); return }
                guard let url = URL(string: profilePictureUrl) else { Service.dismissHud(self.hud, text: "Error", detailText: "Failed to fetch user.", delay: 3); return }
                
                //Unwrapping the url to get the image
                URLSession.shared.dataTask(with: url) { (data, response, err) in
                    if err != nil {
                        guard let err = err else { Service.dismissHud(self.hud, text: "Error", detailText: "Failed to fetch user.", delay: 3); return }
                        Service.dismissHud(self.hud, text: "Fetch error", detailText: err.localizedDescription, delay: 3)
                        return
                    }
                    guard let data = data else { Service.dismissHud(self.hud, text: "Error", detailText: "Failed to fetch user.", delay: 3); return }
                    self.profileImage = UIImage(data: data)
                
                    //If everything was fetched, save the data in firebase
                    MyFirebase.shared.saveUserIntoFirebaseDatabase(name: self.name!, email: self.email!, profileImage: self.profileImage!, loggedIn: false, completion: { isLogedIn in
                        if let isLogedIn = isLogedIn, isLogedIn {
                            self.performSegue(withIdentifier: "goToMain", sender: self)
                        } else {
                            let vc = LogInViewController.storyboardInstance()
                            self.present(vc, animated: true, completion: nil)
                        }
                    })
                    
                    }.resume()
                break
                
            case .failed(let err):
                Service.dismissHud(self.hud, text: "Error", detailText: "Failed to get Facebook user with error: \(err)", delay: 3)
                break
            }
        })
        graphRequestConnection.start()
    }
    
    static func storyboardInstance() -> LogInViewController {
        let storyboard = UIStoryboard(name: "LogInViewController", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
    }

}

