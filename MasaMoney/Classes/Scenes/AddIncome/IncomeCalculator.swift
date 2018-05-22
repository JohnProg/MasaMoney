//
//  IncomeCalculator.swift
//  MasaMoney
//
//  Created by Maria Lopez on 15/05/2018.
//  Copyright © 2018 Maria Lopez. All rights reserved.
//

import UIKit

class IncomeCalculator: UIViewController {

    // MARK: -Outlets
    @IBOutlet weak var incomeTitleLabel: UILabel!{
        didSet {
            incomeTitleLabel.font = UIFont.mmLatoBoldFont(size: 16)
            incomeTitleLabel.textColor = UIColor.mmGrey
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
    
    @IBOutlet var buttonCollection: [RoundButton]!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    // MARK: -Properties
    var accountOrigin = Account()
    
    var accountDestination = Account()
    
    var numberOnScreen : Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for button in buttonCollection {
            button.backColor = UIColor.mmGrey
            button.tintColor = UIColor.white
            button.titleLabel?.font = UIFont.mmLatoSemiBoldFont(size: 30)
            button.cornerRadius = 45
        }
    }
    
    // MARK: - Actions
    @IBAction func numberTapped(_ sender: RoundButton) {
        guard let text = amountLabel.text else {return}
        if text.contains("."){
            if text.components(separatedBy: ".")[1].count != 2{
                amountLabel.text = amountLabel.text! + String(sender.tag-1)
                numberOnScreen = Double(amountLabel.text!)!
            }
        }else{
            amountLabel.text = amountLabel.text! + String(sender.tag-1)
            numberOnScreen = Double(amountLabel.text!)!
        }
    }
    
    @IBAction func functionTapped(_ sender: RoundButton) {
        guard let text = amountLabel.text else {return}
        if sender.tag == 11 && text.contains(".") == false{
            amountLabel.text = text + "."
            numberOnScreen = Double(text)!
        }else if sender.tag == 12 {
            amountLabel.text?.removeLast()
        }
    }
    @IBAction func cancel(_ sender: Any) {
        
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func confirm(_ sender: Any) {
        guard amountLabel.text != nil else {return}
        MyFirebase.shared.updateIncomeBalance(idAccount: accountDestination.id, balance: accountDestination.balance + numberOnScreen)
        
        datePicker.datePickerMode = UIDatePickerMode.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let selectedDate = dateFormatter.string(from: datePicker.date)
        
        MyFirebase.shared.createMovements(origin: accountOrigin.name, destination: accountDestination.name, amount: numberOnScreen, date: selectedDate, originId: accountOrigin.id, destinyId: accountDestination.id)
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    
}
