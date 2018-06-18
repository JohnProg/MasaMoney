//
//  AccountVC.swift
//  MasaMoney
//
//  Created by Maria Lopez on 02/06/2018.
//  Copyright © 2018 Maria Lopez. All rights reserved.
//

import UIKit

enum AccountType {
    case income
    case outcome
    case edit
}

class AccountVC: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var icon: RoundButton!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var nameTitle: UILabel!{
        didSet {
            nameTitle.font = UIFont.mmLatoBoldFont(size: 16)
            nameTitle.textColor = UIColor.mmGrey
            nameTitle.text = Strings.nameAccount
        }
    }
    @IBOutlet weak var acNameTF: UITextField!
    
    @IBOutlet weak var amountTitle: UILabel!{
        didSet {
            amountTitle.font = UIFont.mmLatoBoldFont(size: 16)
            amountTitle.textColor = UIColor.mmGrey
            amountTitle.text = Strings.amountAccount
        }
    }
    @IBOutlet weak var acAmountTF: UITextField!
    
    // MARK: - Properties
    
    var imagesIconString : [String] = ["bills","restaurants","shopping","supplies","transport","bill"]
    var imagesIconStringES : [String] = ["facturas","restaurantes","tiendas","suministros","transporte","billete"]
    var vcType: AccountType  = .income
    var iconString : String = "bills"
    var account = Account()
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupItems()
        
        // Listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    deinit {
        //Stop listening for keyboard hide/show events
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    // MARK: - Functions
    
    func setupItems(){
        acNameTF.delegate = self
        acAmountTF.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ok"), style: .plain, target: self, action: #selector(addTapped))
        
        switch vcType {
        case .income:
            navigationItem.title = Strings.newIncomeAc
            
            navigationItem.setRightBarButton(navigationItem.rightBarButtonItem, animated: false)
            acAmountTF.isHidden = false
            acAmountTF.keyboardType = .decimalPad
            
            deleteButton.isHidden = true
            
        case .outcome:
            navigationItem.title = Strings.newOutcomeAc
            acAmountTF.isHidden = true
            amountTitle.isHidden = true
            
            deleteButton.isHidden = true
            
        case .edit:
            navigationItem.title = Strings.edit
            acNameTF.text = account.name
            iconString = account.icon
            icon.setImage(UIImage(named: account.icon), for: .normal)
            acAmountTF.isHidden = true
            amountTitle.isHidden = true
            deleteButton.isHidden = false
        }
    }
    
    // MARK: - Actions
    
    @objc func addTapped(){
        //Check if field name is empty and show an alert
        guard let name = acNameTF.text, !name.isEmpty else {
            let alert = UIAlertController(style: .alert, title: Strings.emptyField, message: Strings.noName)
            alert.addAction(title: Strings.cancel, style: .cancel)
            alert.show()
            return
        }
        
        // Check if is an income or outcome and create the account
        switch vcType {
        case .income:
            //Check if field amount is empty and show an alert
            guard let amount = acAmountTF.text, !amount.isEmpty else {
                let alert = UIAlertController(style: .alert, title: Strings.emptyField, message: Strings.noAmountNewAccount)
                alert.addAction(title: Strings.cancel, style: .cancel)
                alert.show()
                return
            }
            //Change "," to "." to convert it to double
            let amountDouble = amount.replacingOccurrences(of: ",", with: ".")
            MyFirebase.shared.createAccounts(name: name, balance: Double(amountDouble)!, icon: iconString, income: true)
            
        case .outcome:
            MyFirebase.shared.createAccounts(name: name, balance: 0.0, icon: iconString, income: false)
            
        case .edit:
            MyFirebase.shared.editAccount(idAccount: account.id, name: name, icon: iconString)
        }
        
        //After return to root always
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func didPressDelete(_ sender: Any) {
        
        let alert = UIAlertController(style: .alert, title: Strings.delete, message: Strings.deleteMessage)
        alert.addAction(title: Strings.cancel, style: .cancel)
        alert.addAction(title: Strings.deleteAccount, style: .default){ action in
            MyFirebase.shared.deleteAccount(idAccount: self.account.id)
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
        alert.show()
    }
    
    @IBAction func didPressIcon(_ sender: Any) {
        
        let alert = UIAlertController(style: .actionSheet, title: Strings.icon, message: Strings.iconMessage)
        
        let pickerViewValuesString: [[String]]
        //Check the language to set one array or other in values
        if Locale.preferredLanguages.first?.prefix(2) == "es"{
            pickerViewValuesString = [imagesIconStringES.map { ($0).description }]
        }else{
            pickerViewValuesString = [imagesIconString.map { ($0).description }]
        }
        
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: imagesIconString.index(of: "bills") ?? 0)
        
        alert.addPickerView(values: pickerViewValuesString, initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
            //Set the image with same string in the button image
            DispatchQueue.main.async {
                self.icon.setImage(UIImage(named: self.imagesIconString[index.row]), for: .normal)
                self.iconString = self.imagesIconString[index.row]
            }
        }
        alert.addAction(title: Strings.done, style: .cancel)
        alert.show()
    }
}

extension AccountVC : UITextFieldDelegate {
    
    //Calculate the keyboard
    @objc func keyboardWillChange(notification: Notification) {
        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        //move up showing keyboard or moving down
        if notification.name == Notification.Name.UIKeyboardWillShow || notification.name == Notification.Name.UIKeyboardWillChangeFrame{
            view.frame.origin.y = -keyboardRect.height
        }else{
            view.frame.origin.y = 0
        }
    }
    
    //Press return, change state of keyboard // decimal pad doesn't have return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        acNameTF.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Limit the decimalPad keyboard to two decimals, one dot and max character
        if textField.keyboardType == .decimalPad {
            guard let oldText = textField.text, let r = Range(range, in: oldText) else {
                return true
            }
            
            let newText = oldText.replacingCharacters(in: r, with: string)
            let isNumeric = !newText.isEmpty || (Double(newText) != nil)
            let numberOfDots = newText.components(separatedBy: ",").count - 1
            
            let numberOfDecimalDigits: Int
            if let dotIndex = newText.index(of: ",") {
                numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
            } else {
                numberOfDecimalDigits = 0
            }
            
            if newText.count > 9 {
                return false
            }
            return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
            
        }else{
            // Control max of characters
            let str = (NSString(string: textField.text!)).replacingCharacters(in: range, with: string)
            if str.count >= 20 {
                return false
            }
            return true
        }
    }
}
