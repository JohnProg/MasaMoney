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
            incomeNameLabel.text = account.name
        }
    }
    
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet var buttonCollection: [RoundButton]!
    
    
    
    // MARK: -Properties
    var account = Account()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for button in buttonCollection {
            button.backColor = UIColor.mmGrey
            button.tintColor = UIColor.white
            button.titleLabel?.font = UIFont.mmLatoSemiBoldFont(size: 30)
//            button.widthAnchor.constraint(equalToConstant: 90.0).isActive = true
//            button.heightAnchor.constraint(equalToConstant: 90.0).isActive = true
            button.cornerRadius = 45
        }
    }

    static func storyboardInstance() -> IncomeCalculator {
        let storyboard = UIStoryboard(name: "AddIncome", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "IncomeCalculator") as! IncomeCalculator
    }

}
