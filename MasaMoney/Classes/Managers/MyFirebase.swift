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
    
    func createMovements(origin: String, destination: String, amount: Double, date: String, comment: String, picture: String, originId: String, destinyId: String){
        //Creating accounts
        let movementDictionary = ["origin": origin,
                                  "destination": destination,
                                  "amount": amount,
                                  "date" : date,
                                  "comment" : comment,
                                  "picture" : picture] as [String : Any]
        let movementAccountDictionary = [originId: true,
                                         destinyId: true]
        
        let movId = self.dbRef.child("Movements").child(userId).childByAutoId()
        movId.setValue(movementDictionary)
        movId.child("Accounts").setValue(movementAccountDictionary)

        
    }
    
    func updateIncomeBalance(idAccount: String, balance: Double){
        _ = dbRef.child("Accounts").child(userId).child(idAccount).updateChildValues(["balance": balance])
    }
    
    func editAccount(idAccount: String, name: String, icon: String){
        _ = dbRef.child("Accounts").child(userId).child(idAccount).updateChildValues(["name": name, "icon": icon])
    }
    
    func deleteAccount(idAccount: String){
        _ = dbRef.child("Accounts").child(userId).child(idAccount).removeValue()
    }
    
    
    func loadMovements (account: Account, completion: @escaping ([Movement]?, Error?) -> Void) {
        
        var movementArray: [Movement] = []
        let movementsDB = Database.database().reference().child("Movements").child(MyFirebase.shared.userId)
        movementsDB.keepSynced(true)
        movementsDB.observe(.value, with: { (snapshot) in
            
            if let result = snapshot.children.allObjects as? [DataSnapshot] {
                for child in result {
                    let id = child.key as String
                    movementsDB.child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                        //create a group
                        
                        let snapshotValue = snapshot.value as? NSDictionary
                        
                        guard let origin = snapshotValue!["origin"] as? String else {return}
                        guard let destination = snapshotValue!["destination"] as? String else {return}
                        guard let comment = snapshotValue!["comment"] as? String else {return}
                        guard let picture = snapshotValue!["picture"] as? String else {return}
                        guard let amount = snapshotValue!["amount"] as? Double else {return}
                        guard var date = snapshotValue!["date"] as? String else {return}
                        // sometimes datepicker insert a dot, removing this to avoid error in dateformatter
                        date = date.replacingOccurrences(of: ".", with: "", options: NSString.CompareOptions.literal, range: nil)
                        
                        var movement = Movement()
                        movement.origin = origin
                        movement.destination = destination
                        movement.comment = comment
                        movement.picture = picture
                        movement.amount = amount
                        movement.date = date
                        
                        let dispatchGroup = DispatchGroup()
                        dispatchGroup.enter()
                        
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
                                dispatchGroup.leave()
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
            
            let historic = snapshotValue![account.id] as? Bool
            
            if historic == true {
                completion (movement, nil)
            }
        })
    }
}
