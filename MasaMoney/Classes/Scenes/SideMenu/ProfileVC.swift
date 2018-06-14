//
//  ProfileVC.swift
//  MasaMoney
//
//  Created by Maria Lopez on 04/06/2018.
//  Copyright © 2018 Maria Lopez. All rights reserved.
//

import UIKit
import JGProgressHUD
import Kingfisher

class ProfileVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    
    // MARK: - Outlets
    
    @IBOutlet weak var user_picture: UIImageView!
    
    @IBOutlet weak var user_FirstName: UILabel!{
        didSet {
            user_FirstName.font = UIFont.mmLatoBoldFont(size: 20)
            user_FirstName.textColor = UIColor.mmGrey
        }
    }
    
    @IBOutlet weak var user_Email: UILabel!{
        didSet {
            user_Email.font = UIFont.mmLatoBoldFont(size: 20)
            user_Email.textColor = UIColor.mmGrey
        }
    }
    
    @IBOutlet weak var picker_language: UIPickerView!
    
    // MARK: - Properties
    
    var languages =  [Strings.english,Strings.spanish]
    
    // MARK: - Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker_language.dataSource = self
        picker_language.delegate = self
        
        loadData()
        setPickerView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animatePulseView()
    }
    
    // MARK: - Functions
    
    func loadData(){
        hud.textLabel.text = Strings.loading
        hud.show(in: self.view, animated: true)
        MyFirebase.shared.loadProfile { (user, error) in
            if let error = error {
                //error
                Service.dismissHud(self.hud, text: Strings.errorSignUp, detailText: error.localizedDescription, delay: 3)
            }
            
            if let user = user {
                //Set the information in fields
                self.user_FirstName.text = user.name
                self.user_Email.text = user.email
                self.user_picture.setRounded()
                let url = URL(string: (user.pictureURL))
                self.user_picture.kf.setImage(with: url)
                self.hud.dismiss()
            }
        }
    }
    
    //Pulse effect profile picture
    func animatePulseView(){
        UIView.animate(withDuration: 0.5, animations: {
            self.user_picture.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { (success) in
            self.user_picture.transform = .identity
        }
    }
    
    // Set current language
    func setPickerView(){
        if Locale.preferredLanguages.first?.prefix(2) == "es" {
            picker_language.selectRow(1, inComponent: 0, animated: false)
        } else {
            picker_language.selectRow(0, inComponent: 0, animated: false)
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
        // TODO: - Make an extension
        switch (languageChosen){
        case Strings.spanish:
            let alert = UIAlertController(style: .alert, title: "Cambio de idioma", message: "Para cambiar el idioma debe cambiarlo desde el sistema de su telefono")
            alert.addAction(title: "Mas tarde", style: .cancel)
            alert.addAction(title: "Cambiar ahora", style: .default){ action in
                UIApplication.shared.open(URL(string:"App-Prefs:root=General&path=INTERNATIONAL")!, options: [:], completionHandler: nil)
            }
            alert.show()
        default:
            let alert = UIAlertController(style: .alert, title: "Change language", message: "In order to change the language, you need to change your settings")
            alert.addAction(title: "Later", style: .cancel)
            alert.addAction(title: "Change now", style: .default){ action in
                UIApplication.shared.open(URL(string:"App-Prefs:root=General&path=INTERNATIONAL")!, options: [:], completionHandler: nil)
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
