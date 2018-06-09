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
import FirebaseDatabase
import GoogleSignIn

class Login: UIViewController, GIDSignInUIDelegate {
    
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    
    var name: String? = ""
    var email: String? = ""
    var profileImage: UIImage?
    
    @IBOutlet weak var facebookButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGoogleButton()
        setupFaceButton()
        // Hide the navigation bar on the this view controller
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //MARK: - Actions Buttons
    
    @IBAction func facebookButton(_ sender: Any) {
        hud.textLabel.text = Strings.loggingFacebook
        hud.show(in: view, animated: true)
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: self) { (result) in
            switch result {
            case .success(grantedPermissions: _, declinedPermissions: _, token: _):
                self.signIntoFirebaseWithFacebook()
                
            case .failed(let err):
                Service.dismissHud(self.hud, text: "Error", detailText: "\(Strings.failedFacebook) \(err)", delay: 3)
            case .cancelled:
                Service.dismissHud(self.hud, text: "Error", detailText: "\(Strings.cancelFacebook)", delay: 3)
            }
        }
    }
    
    func setupFaceButton() {
        facebookButton.frame = CGRect(x: 60, y: 512, width: view.frame.width - 115, height: 40)
        view.addSubview(facebookButton)
    }
    
    func setupGoogleButton(){
        let googleButton = GIDSignInButton()
        googleButton.frame = CGRect(x: 60, y: 412, width: view.frame.width - 115, height: 40)
        view.addSubview(googleButton)
        
        GIDSignIn.sharedInstance().uiDelegate = self
    }

    //MARK: - Sign into firebase
    
    func signIntoFirebaseWithFacebook() {
        guard let authenticationToken = AccessToken.current?.authenticationToken else { return }
        let credential = FacebookAuthProvider.credential(withAccessToken: authenticationToken)
        //Authentication with firebase, retrieve info to check if user already exists
        Auth.auth().signInAndRetrieveData(with: credential) { (user, err) in
            if let err = err {
                print(err)
                Service.dismissHud(self.hud, text: Strings.errorSignUp, detailText: err.localizedDescription, delay: 3)
                return
            }
            if(user?.additionalUserInfo?.isNewUser == true) {
                MyFirebase.shared.createBasicAccounts()
                self.fetchFacebookUser()
            }
        }
    }
    
    //MARK: - Fetch Facebook user
    
    func fetchFacebookUser() {
        
        let graphRequestConnection = GraphRequestConnection()
        let graphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "id, email, name, picture.type(large)"], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: .defaultVersion)
        // Make an api call
        graphRequestConnection.add(graphRequest, completion: { (httpResponse, result) in
            switch result {
            // If is a success, fetch info
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
                            let vc: Main = UIStoryboard(.Main).instantiateViewController()
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    })
                    
                    }.resume()
                break
                
            case .failed(let err):
                Service.dismissHud(self.hud, text: "Error", detailText: "\(Strings.failedFacebook) \(err)", delay: 3)
                break
            }
        })
        graphRequestConnection.start()
    }

}

