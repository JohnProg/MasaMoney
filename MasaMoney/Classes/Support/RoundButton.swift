//
//  RoundButton.swift
//  MasaMoney
//
//  Created by Maria Lopez on 13/05/2018.
//  Copyright © 2018 Maria Lopez. All rights reserved.
//

import UIKit

@IBDesignable
class RoundButton: UIButton {
    
    @IBInspectable override var cornerRadius: CGFloat  {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable override var borderWidth: CGFloat  {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    
    @IBInspectable var backColor: UIColor? = UIColor.mmOrangeish {
        didSet {
            self.layer.backgroundColor = backColor?.cgColor
        }
    }
}
