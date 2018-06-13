//
//  MovementCell.swift
//  MasaMoney
//
//  Created by Maria Lopez on 20/05/2018.
//  Copyright © 2018 Maria Lopez. All rights reserved.
//

import UIKit

protocol MovementCellDelegate: class {
    func didSelectImage(with url: String)
}

class MovementCell: UITableViewCell {
    
    // MARK: - Outlets

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
    
    @IBOutlet weak var pictureButton: UIButton!
    
    // MARK: - Properties
    
    var picture = ""
    weak var delegate: MovementCellDelegate?
    
    // MARK: - Awake
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - Functions

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
    
    func configure(movement: Movement, titleAccount: String) {
        origin.text = movement.origin
        destiny.text = movement.destination
        comment.text = movement.comment
        picture = movement.picture!
        
        // Check if is an addition to an income and set style
        if movement.origin ==  "Income"{
            amount.textColor = UIColor.mmGreenish
            amount.text = String(format:"+%g €",movement.amount)

        } else if titleAccount == movement.addition{
            amount.textColor = UIColor.mmGreenish
            amount.text = String(format:"+%g €",movement.amount)
        } else {
            amount.textColor = UIColor.red
            amount.text = String(format:"-%g €",movement.amount)
        }
        
        if picture != "" {
            pictureButton.isHidden = false
        }else {
            pictureButton.isHidden = true
        }
    }
    
    // MARK: - Action
    
    @IBAction func pictureTapped(_ sender: Any) {
        delegate?.didSelectImage(with : picture)
    }
}

