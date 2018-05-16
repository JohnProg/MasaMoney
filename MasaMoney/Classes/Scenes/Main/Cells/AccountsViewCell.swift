//
//  AccountsViewCell.swift
//  MasaMoney
//
//  Created by Maria Lopez on 02/05/2018.
//  Copyright © 2018 Maria Lopez. All rights reserved.
//

import UIKit

class AccountsViewCell: UICollectionViewCell {

  
    @IBOutlet weak var titleLabel: UILabel!{
        didSet {
            titleLabel.font = UIFont.mmLatoSemiBoldFont(size: 14)
            titleLabel.textColor = UIColor.mmGrey
        }
    }
    @IBOutlet weak var icon: UIButton!{
        didSet {
            icon.isUserInteractionEnabled = false
            icon.backgroundColor = UIColor.mmOrangeish
        }
    }
    
    @IBOutlet weak var balanceLabel: UILabel!{
        didSet {
            balanceLabel.font = UIFont.mmLatoSemiBoldFont(size: 14)
            balanceLabel.textColor = UIColor.mmOrangeish
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        icon.setImage(#imageLiteral(resourceName: "money-1"), for: .normal)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = "titulo"
     //   icon.setImage(#imageLiteral(resourceName: "rich"), for: .normal)
        balanceLabel.text = "300"
    }
    
    func configure(account: Account) {
        titleLabel.text = account.name
        balanceLabel.text = String(account.balance)
        if account.income == false {
            icon.backgroundColor = UIColor.mmGreenish
            balanceLabel.textColor = UIColor.mmGreenish
        }
    }
}
