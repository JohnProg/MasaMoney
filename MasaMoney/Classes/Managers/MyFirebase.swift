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
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    
    // MARK: - Properties
    static let shared = MyFirebase()
    var currentUser: User?
    var userId: String = ""
    var dbRef: DatabaseReference! = Database.database().reference()
    
    private var listenHandler: AuthStateDidChangeListenerHandle?
    private init() {
        
    }
    
    // MARK: - Login
    func addUserListener(loggedIn: Bool, completion: @escaping (Bool?) -> Void) {
        listenHandler = Auth.auth().addStateDidChangeListener { (auth, user) in
            if user == nil {
                // We are Logged Out
                self.currentUser = nil
                self.userId = ""
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    completion(loggedIn)
                }
            }
            else {
                if (self.currentUser == nil) {
                    self.currentUser = user
                    self.userId = (user?.uid)!
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
                self.hud.dismiss(animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    completion(true)
                }
            })
        }
    }
    
    // MARK: - Create
    
    func createBasicAccounts(){
        //Creating accounts
        var accountDictionary = ["name": Strings.wallet,
                                 "balance": 0.0,
                                 "icon": "bill",
                                 "income" : true] as [String : Any]
        
        self.dbRef.child("Accounts").child(userId).childByAutoId().setValue(accountDictionary)
        
        accountDictionary = ["name": Strings.bank,
                             "icon": "bill",
                             "balance": 0.0,
                             "income" : true] as [String : Any]
        
        self.dbRef.child("Accounts").child(userId).childByAutoId().setValue(accountDictionary)
        
        accountDictionary = ["name": Strings.groceries,
                             "icon": "supplies",
                             "balance": 0.0,
                             "income" : false] as [String : Any]
        
        self.dbRef.child("Accounts").child(userId).childByAutoId().setValue(accountDictionary)
        
    }
    
    func createAccounts(name: String, balance: Double, icon: String, income: Bool){
        //Creating accounts
        let accountDictionary = ["name": name,
                                 "balance": balance,
                                 "icon": icon,
                                 "income" : income] as [String : Any]
        
        self.dbRef.child("Accounts").child(userId).childByAutoId().setValue(accountDictionary)
    }
    
    func createMovements(origin: String, destination: String, amount: Double, date: String, comment: String, picture: String, originId: String, destinyId: String, addition: String){
        //Creating accounts
        let movementDictionary = ["origin": origin,
                                  "destination": destination,
                                  "amount": amount,
                                  "addition": addition,
                                  "date" : date,
                                  "comment" : comment,
                                  "picture" : picture] as [String : Any]
        let movementAccountDictionary = [originId: true,
                                         destinyId: true]
        
        let movId = self.dbRef.child("Movements").child(userId).childByAutoId()
        movId.setValue(movementDictionary)
        movId.child("Accounts").setValue(movementAccountDictionary)

        
    }
    
    // MARK: - Edit
    
    func updateIncomeBalance(idAccount: String, balance: Double){
        _ = dbRef.child("Accounts").child(userId).child(idAccount).updateChildValues(["balance": balance])
    }
    
    func editAccount(idAccount: String, name: String, icon: String){
        _ = dbRef.child("Accounts").child(userId).child(idAccount).updateChildValues(["name": name, "icon": icon])
    }
    
    func deleteAccount(idAccount: String){
        _ = dbRef.child("Accounts").child(userId).child(idAccount).removeValue()
    }
    
    // MARK: - Storage
    
    func storage(pictureTaken: UIImage, completion: @escaping (String?, Error?) -> Void) {
        //Storaging profile picture
        let profileImageUploadData = UIImageJPEGRepresentation(pictureTaken, 0.3)
        
        let fileName = UUID().uuidString
        Storage.storage().reference().child("movementImages").child(fileName).putData(profileImageUploadData!, metadata: nil) { (metadata, err) in
            let pictureUploaded = (metadata?.downloadURL()?.absoluteString)!
            completion(pictureUploaded, err)
        }
    }
    
    // MARK: - Load
    
    func loadAccounts(completion: @escaping (Account?, Error?) -> Void) {
        //read all the accounts
        let accountsDB = Database.database().reference().child("Accounts").child(userId)
        accountsDB.keepSynced(true)
        accountsDB.observe(.value, with: { (snapshot) in
            //go through every result to get the id and read everyone
            if let result = snapshot.children.allObjects as? [DataSnapshot] {
                for child in result {
                    let id = child.key as String
                    accountsDB.child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                        let account = Account.init(snapshot.value as! NSDictionary)
                        account.id = id                        
                        completion (account, nil)
                    })
                }
            }
        })
    }
    
    func loadMovements (account: Account, completion: @escaping ([Movement]?, Error?) -> Void) {
        
        var movementArray: [Movement] = []
        let movementsDB = Database.database().reference().child("Movements").child(userId)
        movementsDB.keepSynced(true)
        movementsDB.observe(.value, with: { (snapshot) in
            
            if let result = snapshot.children.allObjects as? [DataSnapshot] {
                for child in result {
                    let id = child.key as String
                    movementsDB.child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        let movement = Movement.init(snapshot.value as! [String : Any])
                        
                        self.checkAccountInsideMoves(movementsDB: movementsDB, id: id, account: account, movement: movement, completion: { (movement, error) in
                            if let error = error {
                                //error
                                Service.dismissHud(self.hud, text: Strings.errorSignUp, detailText: error.localizedDescription, delay: 3)
                            }
                            if let movement = movement {
                                //something
                                movementArray.append(movement)
                                DispatchQueue.main.async {
                                    completion(movementArray, nil)
                                }
                            }
                        })
                    })
                }
            }
        })
    }
    
    func checkAccountInsideMoves(movementsDB: DatabaseReference, id: String, account: Account, movement: Movement, completion: @escaping (Movement?, Error?) ->Void) {
        //check if the account is in the movement, if so, add it to the array to show
        movementsDB.child(id).child("Accounts").observeSingleEvent(of: .value, with: { (snapshot) in
            let snapshotValue = snapshot.value as? NSDictionary
            
            guard let historic = snapshotValue![account.id] as? Bool else { return }
            
            if historic{
                completion (movement, nil)
            }
        })
    }
    
    func loadProfile (completion: @escaping (UserProfile?, Error?) -> Void) {
        //read user information from Firebase
        let userDB = Database.database().reference().child("users").child(userId)
        userDB.keepSynced(true)
        userDB.observe(.value, with: { (snapshot) in
            
            let user = UserProfile.init(snapshot.value as! [String : Any])
            
            completion(user, nil)
        })
    }
}
