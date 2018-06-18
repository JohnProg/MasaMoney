//
//  SideMenuVC.swift
//  MasaMoney
//
//  Created by Maria Lopez on 28/05/2018.
//  Copyright © 2018 Maria Lopez. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import MessageUI

class SideMenuVC: UITableViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var atmTitle: UILabel!{
        didSet{
            atmTitle.text = Strings.atm
        }
    }
    @IBOutlet weak var profileTitle: UILabel!{
        didSet{
            profileTitle.text = Strings.perfil
        }
    }
    
    @IBOutlet weak var export: UILabel!{
        didSet{
            export.text = Strings.export
        }
    }
    @IBOutlet weak var logoutTitle: UILabel!{
        didSet{
            logoutTitle.text = Strings.logout
        }
    }
    
    @IBOutlet weak var contactTitle: UILabel!{
        didSet{
            contactTitle.text = Strings.contact
        }
    }
    
    // MARK: -Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView.cellForRow(at: indexPath)?.tag{
        //Map
        case 1:
            let vc: MapVC = UIStoryboard(.Main).instantiateViewController()
            self.navigationItem.title = Strings.back
            self.navigationController?.pushViewController(vc, animated: true)
        //Profile
        case 2:
            let vc: ProfileVC = UIStoryboard(.Main).instantiateViewController()
            self.navigationItem.title = Strings.back
            self.navigationController?.pushViewController(vc, animated: true)
        //Contact
        case 3:
            let email = "contact@masamoney.com"
            let url = URL(string: "mailto:\(email)")
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        //Export
        case 4:
            var csvString = "\(Strings.nameAccount),\(Strings.amountAccount)\n\n"
            self.loadDataEmail { (accountArray) in
                csvString.append(accountArray)
            }
            self.loadMovesEmail(completion: { (movesArray) in
                if !csvString.contains(Strings.movement){
                    csvString.append(movesArray)
                }
                DispatchQueue.global().async {
                    self.sendEmail(csvString: csvString)
                }
            })
            
       //Log out
        case 5:
            try! Auth.auth().signOut()
            FBSDKLoginManager().logOut()
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            let loginStoryboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
            let loginController = loginStoryboard.instantiateViewController(withIdentifier: "Login") as! Login
            let nav = UINavigationController(rootViewController: loginController)
            appdelegate.window!.rootViewController = nav
            
        case .none:
            print("tag none")
            
        case .some(_):
            print("some")
        }
    }
    
    // MARK: -Load Data
    func loadDataEmail(completion: @escaping (String) -> Void)  {
        MyFirebase.shared.loadAccounts { (account, error) in
            var accountsString = ""
            if let account = account {
                accountsString = accountsString.appending("\(String(account.name)) ,\(String(account.balance))\n")
            }
            if error != nil {
                print ("ERROR LOADING ACCOUNTS")
            }
            DispatchQueue.main.async {
                completion(accountsString)
            }
        }
    }
    
    func loadMovesEmail(completion: @escaping (String) -> Void) {
        var movesString = "\n\n\(Strings.movement)\n\n"
        movesString = movesString.appending("\(Strings.origin),\(Strings.destiny),\(Strings.amountAccount),\(Strings.date),\(Strings.comment)\n\n")
        MyFirebase.shared.loadAllMovements { (mov, error) in
            if let mov = mov {
                movesString = movesString.appending("\(String(mov.origin)) ,\(String(mov.destination)),\(String(mov.amount)),\(String(mov.date)),\(mov.comment)\n")
            }
            if error != nil {
                print ("ERROR LOADING ACCOUNTS")
            }
            DispatchQueue.main.async {
                completion(movesString)
            }
        }
    }
    
    func sendEmail(csvString : String) {
        if MFMailComposeViewController.canSendMail() {
            let emailController = MFMailComposeViewController()
            emailController.mailComposeDelegate = self
            emailController.setSubject("CSV File")
            emailController.setToRecipients(["mari.lopez.sanchez@gmail.com"])
            emailController.setMessageBody("", isHTML: false)

            // Attaching the .CSV file to the email.
            emailController.addAttachmentData(csvString.data(using: .utf8)!, mimeType: "text/csv", fileName: "Projects.csv")
            self.present(emailController, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check if mail was sent
        if result == .sent {
            // Add another dismiss so we're back to the settings screen
            dismiss(animated: true, completion: nil)
        }
        dismiss(animated: true, completion: nil)
    }
}
