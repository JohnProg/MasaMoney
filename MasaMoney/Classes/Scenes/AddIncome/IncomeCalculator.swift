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
    
    @IBOutlet var buttonCollection: [RoundButton]!
    
    
    // MARK: -Properties
    var accountOrigin = Account()
    
    var accountDestination = Account()
    
    var selectedDate : String = ""
    
    var dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        dateFormatter.dateFormat = "dd MMM yyyy"
        selectedDate = dateFormatter.string(from: Date())
        dateButton.setTitle(selectedDate, for: .normal)

        for button in buttonCollection {
            button.backColor = UIColor.mmGrey
            button.tintColor = UIColor.white
            button.titleLabel?.font = UIFont.mmLatoSemiBoldFont(size: 30)
            button.cornerRadius = 37.5
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
    
    @IBAction func cancel(_ sender: Any) {
        
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func confirm(_ sender: Any) {
        guard let  amount = amountLabel.text, !amount.isEmpty else {
            let alert = UIAlertController(style: .alert, title: Strings.emptyField, message: Strings.noAmount)
            alert.addAction(title: Strings.cancel, style: .cancel)
            alert.show()
            return}
        // Update balance in the accounts except if it is an addition to an income account
        MyFirebase.shared.updateIncomeBalance(idAccount: accountDestination.id, balance: accountDestination.balance + Double(amount)!)
        if accountOrigin.id != "External"{
            MyFirebase.shared.updateIncomeBalance(idAccount: accountOrigin.id, balance: accountOrigin.balance - Double(amount)!)
        }
        // create the movement
        print(selectedDate)
        MyFirebase.shared.createMovements(origin: accountOrigin.name, destination: accountDestination.name, amount: Double(amount)!, date: selectedDate, originId: accountOrigin.id, destinyId: accountDestination.id)
        _ = self.navigationController?.popToRootViewController(animated: true)
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
}

