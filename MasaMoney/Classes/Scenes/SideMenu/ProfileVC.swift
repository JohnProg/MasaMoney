//
//  ProfileVC.swift
//  MasaMoney
//
//  Created by Maria Lopez on 04/06/2018.
//  Copyright © 2018 Maria Lopez. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class ProfileVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - Outlets
    
    @IBOutlet weak var user_picture: UIImageView!
    
    @IBOutlet weak var user_FirstName: UILabel!
    
    @IBOutlet weak var user_Email: UILabel!
    
    @IBOutlet weak var picker_language: UIPickerView!
    
    // MARK: - Properties
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    
    var languages =  [Strings.english,Strings.spanish]
    
    // MARK: - Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()

        picker_language.dataSource = self
        picker_language.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animatePulseView()
    }
    
    // MARK: - Functions
    
    func loadData(){
        hud.textLabel.text = Strings.loading
        hud.show(in: self.view, animated: true)
        //read user information from Firebase
        let userDB = Database.database().reference().child("users").child(MyFirebase.shared.userId)
        userDB.keepSynced(true)
        userDB.observe(.value, with: { (snapshot) in
            
            let snapshotValue = snapshot.value as? NSDictionary
            let name = snapshotValue!["name"] as? String
            let email = snapshotValue!["email"] as? String
            let profileImageUrl = snapshotValue!["profileImageUrl"] as? String
            
            //Set the information in fields
            self.user_FirstName.text = name
            self.user_Email.text = email
            self.user_picture.setRounded()
            let url = URL(string: profileImageUrl!)
            if let data = try? Data(contentsOf: url!)
            {
                self.user_picture.image  = UIImage(data: data)
            }
            self.hud.dismiss()
        })
    }
    //Pulse effect profile picture
    func animatePulseView(){
        UIView.animate(withDuration: 0.5, animations: {
            self.user_picture.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { (success) in
            self.user_picture.transform = .identity
        }
    }
    
    // MARK: - PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languages[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let languageChosen = (languages[picker_language.selectedRow(inComponent: 0)])
        
        switch (languageChosen){
        case Strings.spanish:
            UserDefaults.standard.set(["es"], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
            let alert = UIAlertController(style: .alert, title: "Reinicio de app necesario", message: "Para que el idioma cambie es necesario cerrar y volver a abrir la aplicacion")
            alert.addAction(title: "Mas tarde", style: .cancel)
            alert.addAction(title: "Cerrar ahora", style: .default){ action in
                exit(EXIT_SUCCESS)
            }
            alert.show()
        default:
            print("English")
            UserDefaults.standard.set(["en"], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
            let alert = UIAlertController(style: .alert, title: "App restart required", message: "In order to change the language, the App must be closed and reopened by you")
            alert.addAction(title: "Later", style: .cancel)
            alert.addAction(title: "Close now", style: .default){ action in
                exit(EXIT_SUCCESS)
            }
            alert.show()
        }
    }
}

extension UIImageView {
    
    func setRounded() {
        self.layer.cornerRadius = (self.frame.width / 2)
        self.layer.masksToBounds = true
    }
}
