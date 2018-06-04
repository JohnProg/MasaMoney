//
//  AddAccountVC.swift
//  MasaMoney
//
//  Created by Maria Lopez on 02/06/2018.
//  Copyright © 2018 Maria Lopez. All rights reserved.
//

import UIKit

enum AccountType {
    case income
    case outcome
}

class AddAccountVC: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var icon: RoundButton!
    
    @IBOutlet weak var nameTitle: UILabel!{
        didSet {
            nameTitle.font = UIFont.mmLatoBoldFont(size: 16)
            nameTitle.textColor = UIColor.mmGrey
            nameTitle.text = "Name of the account"
        }
    }
    @IBOutlet weak var acNameTF: UITextField!
    
    @IBOutlet weak var amountTitle: UILabel!{
        didSet {
            amountTitle.font = UIFont.mmLatoBoldFont(size: 16)
            amountTitle.textColor = UIColor.mmGrey
            amountTitle.text = "Amount"
        }
    }
    @IBOutlet weak var acAmountTF: UITextField!
    
    // MARK: - Properties
    
    var imagesIconString : [String] = ["bills","restaurants","shopping","supplies","transport","bill"]
    var vcType: AccountType  = .income
    var iconString : String = "bill"
    
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
    
    func setupItems(){
        acNameTF.delegate = self
        acAmountTF.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ok"), style: .plain, target: self, action: #selector(addTapped))
        
        switch vcType {
        case .income:
            navigationItem.title = "Create income account"
            
            navigationItem.setRightBarButton(navigationItem.rightBarButtonItem, animated: false)
            acAmountTF.isHidden = false
            acAmountTF.keyboardType = .decimalPad
            
        case .outcome:
            navigationItem.title = "Create outcome account"
            acAmountTF.isHidden = true
            amountTitle.isHidden = true
        }
    }
    
    @objc func addTapped(){
        guard let name = acNameTF.text, !name.isEmpty else {
            let alert = UIAlertController(style: .alert, title: "No name", message: "No text introduced")
            alert.show()
            return
        }
        
        switch vcType {
        case .income:
            guard let amount = acAmountTF.text, !amount.isEmpty else {
                let alert = UIAlertController(style: .alert, title: "No amount", message: "No amount introduced")
                alert.show()
                return
            }
            MyFirebase.shared.createAccounts(name: name, balance: Double(amount)!, icon: iconString, income: true)
            
        case .outcome:
            MyFirebase.shared.createAccounts(name: name, balance: 0.0, icon: iconString, income: false)
        }
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func didPressIcon(_ sender: Any) {
        
        let alert = UIAlertController(style: .actionSheet, title: "Icon image", message: "Choose your icon image")
        
        let pickerViewValuesString: [[String]] = [imagesIconString.map { ($0).description }]
        
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: imagesIconString.index(of: "bills") ?? 0)
        
        alert.addPickerView(values: pickerViewValuesString, initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
            DispatchQueue.main.async {
                self.icon.setImage(UIImage(named: self.imagesIconString[index.row]), for: .normal)
                self.iconString = self.imagesIconString[index.row]
            }
        }
        alert.addAction(title: "Done", style: .cancel)
        alert.show()
    }
    
    // MARK: - UITextFieldDelegate Methods
    
    @objc func keyboardWillChange(notification: Notification) {
        //Calculate the keyboard
        guard let keyboardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        //move up showing keyboard or movind down
        if notification.name == Notification.Name.UIKeyboardWillShow || notification.name == Notification.Name.UIKeyboardWillChangeFrame{
            view.frame.origin.y = -keyboardRect.height
        }else{
            view.frame.origin.y = 0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        acNameTF.resignFirstResponder()
        acAmountTF.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.keyboardType == .decimalPad {
            guard let oldText = textField.text, let r = Range(range, in: oldText) else {
                return true
            }
            
            let newText = oldText.replacingCharacters(in: r, with: string)
            let isNumeric = newText.isEmpty || (Double(newText) != nil)
            let numberOfDots = newText.components(separatedBy: ".").count - 1
            
            let numberOfDecimalDigits: Int
            if let dotIndex = newText.index(of: ".") {
                numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
            } else {
                numberOfDecimalDigits = 0
            }
            
            return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
        }else{
            return true
        }
        
    }
}
