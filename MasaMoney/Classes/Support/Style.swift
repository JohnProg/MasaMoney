//
//  Style.swift
//  MasaMoney
//
//  Created by Maria Lopez on 12/05/2018.
//  Copyright © 2018 Maria Lopez. All rights reserved.
//

import UIKit

// MARK: - Colors
extension UIColor {
    class var mmGrey: UIColor {
        return UIColor(red: 150.0 / 255.0, green: 159.0 / 255.0, blue: 170.0 / 255.0, alpha: 1.0)
    }
    class var mmOrangeish: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 200.0 / 255.0, blue: 44.0 / 255.0, alpha: 0.45)
    }
    class var mmGreenish: UIColor {
        return UIColor(red: 119.0 / 255.0, green: 211.0 / 255.0, blue: 83.0 / 255.0, alpha: 1.0)
    }
    class var mmBlackish: UIColor {
        return UIColor(red: 71.0 / 255.0, green: 82.0 / 255.0, blue: 94.0 / 255.0, alpha: 1.0)
    }
    class var fdkReddishOrange: UIColor {
        return UIColor(red: 248.0 / 255.0, green: 68.0 / 255.0, blue: 22.0 / 255.0, alpha: 1.0)
    }
    
}

// MARK: - Fonts
extension UIFont {
    
    // LATO
    class func mmLatoThinFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Lato-Thin", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    class func mmLatoMediumFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Lato-Medium", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    class func mmLatoBoldFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Lato-Bold", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
    class func mmLatoSemiBoldFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Lato-Semibold", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
