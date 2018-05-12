//
//  AccountsViewCell.swift
//  MasaMoney
//
//  Created by Maria Lopez on 02/05/2018.
//  Copyright © 2018 Maria Lopez. All rights reserved.
//

import UIKit

protocol AccountViewInput: class {
    func configure(_ title: String, balance: Double)
}

class AccountsViewCell: UICollectionViewCell {

  
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var icon: UIButton!
    @IBOutlet weak var balanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        icon.setImage(#imageLiteral(resourceName: "rich"), for: .normal)
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
        print(account.name)
        print(account.balance)
    }
}

//extension AccountsViewCell: AccountViewInput {
//    func configure(account: Account) {
//        titleLabel.text = title
//        balanceLabel.text = String(balance)
//    }
//}
