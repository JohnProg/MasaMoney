//
//  MovementCell.swift
//  MasaMoney
//
//  Created by Maria Lopez on 20/05/2018.
//  Copyright © 2018 Maria Lopez. All rights reserved.
//

import UIKit

class MovementCell: UITableViewCell {

    @IBOutlet weak var origin: UILabel!{
        didSet {
            origin.font = UIFont.mmLatoSemiBoldFont(size: 18)
            origin.textColor = UIColor.mmGrey
        }
    }
    @IBOutlet weak var destiny: UILabel!{
        didSet {
            destiny.font = UIFont.mmLatoSemiBoldFont(size: 18)
            destiny.textColor = UIColor.mmBlackish
        }
    }
    @IBOutlet weak var amount: UILabel!{
        didSet {
            amount.font = UIFont.mmLatoSemiBoldFont(size: 25)
            amount.textColor = UIColor.mmBlackish
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        origin.text = "origen"
        //   icon.setImage(#imageLiteral(resourceName: "rich"), for: .normal)
        destiny.text = "destination"
        amount.text = "5€"
    }
    
    func configure(movement: Movement) {
        origin.text = movement.origin
        destiny.text = movement.destination
        if movement.amount < 0 {
            amount.textColor = UIColor.red
        }
        amount.text = String(movement.amount)
    }
    
}
