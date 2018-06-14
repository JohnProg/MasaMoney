//
//  CalculatorVC.swift
//  MasaMoney
//
//  Created by Maria Lopez on 15/05/2018.
//  Copyright © 2018 Maria Lopez. All rights reserved.
//

import UIKit
import JGProgressHUD

class CalculatorVC: UIViewController {
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()

    // MARK: -Outlets
    
    @IBOutlet weak var commentButton: UIButton!{
        didSet{
            commentButton.setBackgroundImage(#imageLiteral(resourceName: "quepal"), for: .selected)
            commentButton.backgroundColor = UIColor.mmGrey
            commentButton.setRounded()
        }
    }
    
    @IBOutlet weak var pictureButton: UIButton!{
        didSet{
            pictureButton.setBackgroundImage(#imageLiteral(resourceName: "quepal"), for: .selected)
            pictureButton.backgroundColor = UIColor.mmGrey
            pictureButton.setRounded()
        }
    }
    
    @IBOutlet weak var dateButton: UIButton!{
        didSet {
            dateButton.setImage(#imageLiteral(resourceName: "calendar"), for: .normal)
            dateButton.imageView?.contentMode = UIViewContentMode.scaleAspectFill
            dateButton.imageView?.tintColor = UIColor.mmGrey
            dateButton.titleLabel?.font = UIFont.mmLatoBoldFont(size: 20)
            dateButton.titleLabel?.tintColor = UIColor.mmGrey
            dateButton.titleLabel?.textColor = UIColor.mmGrey
        }
    }
    
    @IBOutlet weak var incomeTitleLabel: UILabel!{
        didSet {
            incomeTitleLabel.font = UIFont.mmLatoBoldFont(size: 16)
            incomeTitleLabel.textColor = UIColor.mmGrey
            incomeTitleLabel.text = "\(accountOrigin.name) > "
        }
    }
    
    @IBOutlet weak var incomeNameLabel: UILabel!{
        didSet {
            incomeNameLabel.font = UIFont.mmLatoBoldFont(size: 16)
            incomeNameLabel.textColor = UIColor.mmGrey
            incomeNameLabel.text = accountDestination.name
        }
    }
    
    @IBOutlet weak var amountLabel: UILabel!{
        didSet {
            amountLabel.font = UIFont.mmLatoBoldFont(size: 35)
            amountLabel.textColor = UIColor.white
            amountLabel.textAlignment = .right
        }
    }
    
    @IBOutlet var buttonCollection: [RoundButton]!{
        didSet{
            for button in buttonCollection {
                button.backColor = UIColor.mmGrey
                button.tintColor = UIColor.white
                button.titleLabel?.font = UIFont.mmLatoSemiBoldFont(size: 30)
                button.widthAnchor.constraint(equalToConstant: 70).isActive = true
                button.heightAnchor.constraint(equalToConstant: 70).isActive = true
                button.cornerRadius = 35
            }
        }
    }
    
    // MARK: -Properties
    var accountOrigin = Account()
    
    var accountDestination = Account()
    
    var selectedDate : String = ""
    
    var comment : String = ""
    
    var pictureTaken: UIImage?
    
    var pictureUploaded : String = ""
    
    private var dateFormatter = DateFormatter()
    
    private let obscuraCamera = Obscura()
    
    // MARK: - Views
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        dateFormatter.dateFormat = "dd MMM yyyy"
        selectedDate = dateFormatter.string(from: Date())
        dateButton.setTitle(selectedDate, for: .normal)
        
        obscuraCamera.imagePickedBlock = {[weak self] (response) in
            switch response {
            case ObscuraImageResponse.success(let imageResponse):
                self?.pictureTaken = imageResponse.image
                self?.pictureButton.isSelected = true
                
            case ObscuraImageResponse.failed(_):
                Service.dismissHud((self?.hud)!, text: "error view load income calculator", detailText: "error", delay: 3)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Actions
    
    @IBAction func numberTapped(_ sender: RoundButton) {
        //Check that the number screen is not empty
        guard let text = amountLabel.text, text.count < 8 else {return}
        //Check if there is already a decimal point and limit it to 2 decimals
        if text.contains("."){
            if text.components(separatedBy: ".")[1].count != 2{
                amountLabel.text = amountLabel.text! + String(sender.tag-1)
            }
        }else{
            amountLabel.text = amountLabel.text! + String(sender.tag-1)
        }
    }
    
    @IBAction func functionTapped(_ sender: RoundButton) {
        guard let text = amountLabel.text else {return}
        if sender.tag == 11 && text.contains(".") == false{
            amountLabel.text = text + "."
        }else if sender.tag == 12 {
            amountLabel.text?.removeLast()
        }
    }
    
    @IBAction func commentTapped(_ sender: Any) {
        let alert = UIAlertController(style: .alert, title: Strings.comment)
        let config: TextField.Config = { textField in
            textField.becomeFirstResponder()
            textField.textColor = .black
            textField.text = self.comment
            textField.left(image: #imageLiteral(resourceName: "pencil"), color: .black)
            textField.leftViewPadding = 12
            textField.borderWidth = 1
            textField.cornerRadius = 8
            textField.borderColor = UIColor.lightGray.withAlphaComponent(0.5)
            textField.backgroundColor = nil
            textField.keyboardAppearance = .default
            textField.keyboardType = .default
            textField.returnKeyType = .done
            textField.action { textField in
                self.comment = textField.text!
                if self.comment != ""{
                    self.commentButton.isSelected = true
                }else{
                    self.commentButton.isSelected = false
                }
            }
        }
        alert.addOneTextField(configuration: config)
        alert.addAction(title: "OK", style: .cancel)
        alert.show()
    }
    
    @IBAction func pictureTapped(_ sender: Any) {
        //Check connection
        if Reachability.isConnectedToNetwork(){
            //If there is a picture taken and user tap, the picture is deleted and button turns able to pick another one
            if pictureButton.isSelected == true {
                pictureButton.isSelected = false
                pictureTaken = nil
            } else if pictureButton.isSelected == false {
                let alert = UIAlertController(title: Strings.picture, message: nil, preferredStyle: .actionSheet)
                let oKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(UIAlertAction(title: Strings.pictureGallery, style: .default) { [weak self] _ in
                    do {
                        if let currentVC = self {
                            try currentVC.obscuraCamera.chooseFromGallery(viewController: currentVC)
                        }
                    } catch {
                        let alertNoCamera = UIAlertController(title: Strings.pictureError, message: nil, preferredStyle: .alert)
                        alertNoCamera.addAction(oKAction)
                        self?.present(alertNoCamera, animated: true, completion: nil)
                    }
                })
                alert.addAction(UIAlertAction(title: Strings.pictureCamera, style: .default) { [weak self] _ in
                    do {
                        if let currentVC = self {
                            try currentVC.obscuraCamera.takePhoto(viewController: currentVC)
                        }
                    } catch {
                        let alertNoCamera = UIAlertController(title: Strings.pictureError, message: nil, preferredStyle: .alert)
                        alertNoCamera.addAction(oKAction)
                        self?.present(alertNoCamera, animated: true, completion: nil)
                    }
                })
                alert.addAction(UIAlertAction(title: Strings.cancel, style: UIAlertActionStyle.cancel, handler: nil))
                alert.show()
            }
        }else{
            let alert = UIAlertController(style: .alert, title: Strings.noConnection, message: Strings.noConnectionMessage)
            alert.addAction(title: Strings.cancel, style: .cancel)
            alert.show()
        }
    }
    
    @IBAction func dateTapped() {
        
        let alert = UIAlertController(style: .actionSheet, title: "Select date")
        alert.addDatePicker(mode: .date, date: Date(), minimumDate: NSDate.distantPast, maximumDate: NSDate.distantFuture) { date in
            self.selectedDate = self.dateFormatter.string(from: date)
            self.dateButton.setTitle(self.selectedDate, for: .normal)
        }
        alert.addAction(title: "OK", style: .cancel)
        alert.show()
    }    

    @IBAction func cancel(_ sender: Any) {
        
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func confirm(_ sender: Any) {
        hud.textLabel.text = Strings.saving
        hud.show(in: view, animated: true)
        // Storage picture if there is one
        if pictureTaken != nil {
            MyFirebase.shared.storage(pictureTaken: pictureTaken!) { (pictureUploaded, error) in
                if let error = error {
                    Service.dismissHud((self.hud), text: "Error", detailText: "Failed to save user with error: \(error)", delay: 3)
                }
                if let pictureUploaded = pictureUploaded {
                    self.pictureUploaded = pictureUploaded
                    self.savingMovement()
                }
            }
        } else {
            savingMovement()
        }
    }
    
    func savingMovement() {
        // Check the textfield is not empty
        guard let  amount = amountLabel.text, !amount.isEmpty else {
            let alert = UIAlertController(style: .alert, title: Strings.emptyField, message: Strings.noAmount)
            alert.addAction(title: Strings.cancel, style: .cancel)
            alert.show()
            return}
        
        // Update balance in the accounts except if it is an addition to an income account
        MyFirebase.shared.updateIncomeBalance(idAccount: accountDestination.id, balance: accountDestination.balance + Double(amount)!)
        if self.accountOrigin.id != "External"{
            MyFirebase.shared.updateIncomeBalance(idAccount: accountOrigin.id, balance: accountOrigin.balance - Double(amount)!)
        }
        
        // Check if is an addition
        var addition = ""
        if accountOrigin.income == true && accountDestination.income == true {
            addition = accountDestination.name
        }
        // create the movement
        MyFirebase.shared.createMovements(origin: accountOrigin.name, destination: accountDestination.name, amount: Double(amount)!, date: selectedDate, comment: comment, picture: pictureUploaded, originId: accountOrigin.id, destinyId: accountDestination.id, addition: addition)
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
}

extension UIButton {
    
    func setRounded() {
        self.layer.cornerRadius = (self.frame.width / 2)
        self.layer.masksToBounds = true
    }
}

