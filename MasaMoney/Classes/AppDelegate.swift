//
//  AppDelegate.swift
//  MasaMoney
//
//  Created by Maria Lopez on 16/04/2018.
//  Copyright © 2018 Maria Lopez. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FBSDKCoreKit
import GoogleSignIn
import JGProgressHUD
import Fabric


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    var window: UIWindow?
    var locationManager: CLLocationManager?
    var image : UIImage?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //Firebase
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        
        //Facebook
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //Google
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        //MAP
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        
        //Crashlytics
        Fabric.sharedSDK().debug = true
        
        return true
    }
    
    //Google sign in
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: options [UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        Service.dismissHud(self.hud, text: Strings.loggingGoogle, detailText: Strings.loggingGoogle, delay: 3)
        if let err = error {
            Service.dismissHud(self.hud, text: Strings.errorSignUp, detailText: err.localizedDescription, delay: 3)
            return
        }
        guard let idToken = user.authentication.idToken else {return}
        guard let accessToken = user.authentication.accessToken else {return}
        let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        guard let name = user.profile.name else {return}
        guard let email = user.profile.email else {return}
        guard let url = user.profile.imageURL(withDimension: 50) else {return}
        
        //if exists, charge the image from the url
        let data = try? Data(contentsOf: url)
        if let data = data {
            image = UIImage(data: data)
        }
        //Authentication with firebase, retrieve info to check if user already exists
        Auth.auth().signInAndRetrieveData(with: credentials) { (user, err) in
            if let err = err {
                Service.dismissHud(self.hud, text: Strings.errorSignUp, detailText: err.localizedDescription, delay: 3)
                return
            }
            if(user?.additionalUserInfo?.isNewUser == true) {
                MyFirebase.shared.createBasicAccounts()
                //If everything was fetched, save the data in firebase
                MyFirebase.shared.saveUserIntoFirebaseDatabase(name: name, email: email, profileImage: self.image!, loggedIn: false, completion: { isLogedIn in
                    if let isLogedIn = isLogedIn, isLogedIn {
                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let mainController = mainStoryboard.instantiateViewController(withIdentifier: "Main") as! Main
                        let nav = UINavigationController(rootViewController: mainController)
                        self.window!.rootViewController = nav
                    }
                })
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        try! Auth.auth().signOut()
        let loginStoryboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let loginController = loginStoryboard.instantiateViewController(withIdentifier: "Login") as! Login
        let nav = UINavigationController(rootViewController: loginController)
        window!.rootViewController = nav
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        MyFirebase.shared.removeUserListener()
    }
    
}


