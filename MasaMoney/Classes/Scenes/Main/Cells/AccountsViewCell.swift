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
            icon.backgroundColor = UIColor.mmGreenish
            icon.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        }
    }
    
    @IBOutlet weak var balanceLabel: UILabel!{
        didSet {
            balanceLabel.font = UIFont.mmLatoSemiBoldFont(size: 14)
            balanceLabel.textColor = UIColor.mmGreenish
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        icon.setImage(#imageLiteral(resourceName: "bill"), for: .normal)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = "titulo"
        icon.setImage(#imageLiteral(resourceName: "bill"), for: .normal)
        balanceLabel.text = "0"
    }
    
    func configure(account: Account) {
        titleLabel.text = account.name
        balanceLabel.text = String(format:"%g €",account.balance)
        icon.setImage(UIImage(named: account.icon) , for: .normal)
        if account.income != false {
            icon.backgroundColor = UIColor.mmOrangeish
            balanceLabel.textColor = UIColor.mmGoldish
            if account.balance < 0 {
                balanceLabel.textColor = UIColor.red
            }
        }
    }
}
