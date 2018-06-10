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
    
    @IBOutlet weak var comment: UILabel!{
        didSet {
            comment.font = UIFont.mmLatoSemiBoldFont(size: 15)
            comment.textColor = UIColor.mmGreenish
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
        comment.text = ""
        destiny.text = "destination"
        amount.text = "5€"
    }
    
    func configure(movement: Movement) {
        origin.text = movement.origin
        destiny.text = movement.destination
        comment.text = movement.comment
        
        // Check if is an addition to an income and set style
        if movement.origin !=  "Income" {
            amount.textColor = UIColor.red
            amount.text = String(format:"-%g €",movement.amount)
        }else{
            amount.textColor = UIColor.mmGreenish
            amount.text = String(format:"+%g €",movement.amount)
        }
        
    }
    
}
