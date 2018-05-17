//
//  MyFirebase.swift
//  MasaMoney
//
//  Created by Maria Lopez on 16/04/2018.
//  Copyright © 2018 Maria Lopez. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import JGProgressHUD

class MyFirebase {
    
    static let shared = MyFirebase()
    // Declare instance variables here
    var currentUser: User?
    var userId: String = ""
    var dbRef: DatabaseReference! = Database.database().reference()
    
    private var listenHandler: AuthStateDidChangeListenerHandle?
    
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    
    private init() {
        
    }
    
    func addUserListener(loggedIn: Bool, completion: @escaping (Bool?) -> Void) {
        print ("Add listener")
        listenHandler = Auth.auth().addStateDidChangeListener { (auth, user) in
            if user == nil {
                // We are Logged Out
                print("Logged Out")
                self.currentUser = nil
                self.userId = ""
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    completion(loggedIn)
                }
            }
            else {
                print ("Logged In")
                
                if (self.currentUser == nil) {
                    self.currentUser = user
                    self.userId = (user?.uid)!
                    print ("userId -> \(self.userId)")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        completion(true)
                    }
                }
            }
        }
    }
    func isLoggedIn() -> Bool {
        return(currentUser != nil)
    }
    
    func removeUserListener() {
        guard listenHandler != nil else {
            return
        }
        Auth.auth().removeStateDidChangeListener(listenHandler!)
    }
    
    
    
    func saveUserIntoFirebaseDatabase(name: String, email: String, profileImage: UIImage, loggedIn: Bool, completion: @escaping (Bool?) -> Void) {
        
        
        //Storaging profile picture
        guard let profileImageUploadData = UIImageJPEGRepresentation(profileImage, 0.3) else { Service.dismissHud(hud, text: "Error", detailText: "Failed to save user.", delay: 3); return }
        let fileName = UUID().uuidString
        
        Storage.storage().reference().child("profileImages").child(fileName).putData(profileImageUploadData, metadata: nil) { (metadata, err) in
            if let err = err {
                Service.dismissHud(self.hud, text: "Error", detailText: "Failed to save user with error: \(err)", delay: 3);
                return
            }
            guard let profileImageUrl = metadata?.downloadURL()?.absoluteString else { Service.dismissHud(self.hud, text: "Error", detailText: "Failed to save user.", delay: 3); return }
            print("Successfully uploaded profile image into Firebase storage with URL:", profileImageUrl)
            
            let dictionaryValues = ["name": name,
                                    "email": email,
                                    "profileImageUrl": profileImageUrl]
            let values = [self.userId : dictionaryValues]
            
            // Updating user values
            self.dbRef.child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
                if let err = err {
                    Service.dismissHud(self.hud, text: "Error", detailText: "Failed to save user info with error: \(err)", delay: 3)
                    return
                }
                print("Successfully saved user info into Firebase database")
                // after successfull save dismiss the welcome view controller
                self.hud.dismiss(animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    completion(true)
                }
            })
        }
    }
    
    func createBasicAccounts(){
        //Creating accounts
        var accountDictionary = ["name": "Wallet",
                                 "balance": 0.0,
                                 "income" : true] as [String : Any]
        
        self.dbRef.child("Accounts").child(self.userId).childByAutoId().setValue(accountDictionary)
        
        accountDictionary = ["name": "Bank account",
                             "balance": 0.0,
                             "income" : true] as [String : Any]
        
        self.dbRef.child("Accounts").child(self.userId).childByAutoId().setValue(accountDictionary)
        
        accountDictionary = ["name": "Groceries",
                             "balance": 0.0,
                             "income" : false] as [String : Any]
        
        self.dbRef.child("Accounts").child(self.userId).childByAutoId().setValue(accountDictionary)
        
    }
    
    func updateIncomeBalance(idAccount: String, balance: Double){
        _ = dbRef.child("Accounts").child(self.userId).child(idAccount).updateChildValues(["balance": balance])
    }
    
}
