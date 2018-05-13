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
    class var fdkReddishOrange: UIColor {
        return UIColor(red: 248.0 / 255.0, green: 68.0 / 255.0, blue: 22.0 / 255.0, alpha: 1.0)
    }
    
    class var fdkGreyishBrown: UIColor {
        return UIColor(white: 74.0 / 255.0, alpha: 1.0)
    }
    
    class var fdkWarmGrey: UIColor {
        return UIColor(white: 155.0 / 255.0, alpha: 1.0)
    }
    
    class var fdkLightSkyBlue: UIColor {
        return UIColor(red: 190.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    }
    
    class var fdkDark: UIColor {
        return UIColor(red: 28.0 / 255.0, green: 35.0 / 255.0, blue: 38.0 / 255.0, alpha: 1.0)
    }
    
    class var fdkGreyishBrown40: UIColor {
        return UIColor(white: 74.0 / 255.0, alpha: 0.4)
    }
    
    class var fdkFaceBookBlue: UIColor {
        return UIColor(red: 59.0 / 255.0, green: 88.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0)
    }
    
    class var fdkCharcoalGrey: UIColor {
        return UIColor(red: 74.0 / 255.0, green: 74.0 / 255.0, blue: 74.0 / 255.0, alpha: 1.0)
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
    
    class func fdkLatoThin80Font() -> UIFont {
        return UIFont(name: "Lato-Thin", size: 80.0) ?? UIFont.systemFont(ofSize: 80)
    }
    
    class func fdkLatoMedium11Font() -> UIFont {
        return UIFont(name: "Lato-Medium", size: 11.0) ?? UIFont.systemFont(ofSize: 11)
    }
    
    class func fdkLatoMedium10Font() -> UIFont {
        return UIFont(name: "Lato-Medium", size: 10.0) ?? UIFont.systemFont(ofSize: 10)
    }
    
    class func fdkLatoMedium9Font() -> UIFont {
        return UIFont(name: "Lato-Medium", size: 9.0) ?? UIFont.systemFont(ofSize: 9)
    }
    
    class func fdkLatoMedium12Font() -> UIFont {
        return UIFont(name: "Lato-Medium", size: 12.0) ?? UIFont.systemFont(ofSize: 12)
    }
    
    class func fdkLatoMedium15Font() -> UIFont {
        return UIFont(name: "Lato-Medium", size: 15.0) ?? UIFont.systemFont(ofSize: 15)
    }
    
    class func fdkLatoBold8Font() -> UIFont {
        return UIFont(name: "Lato-Bold", size: 8.0) ?? UIFont.boldSystemFont(ofSize: 8)
    }
    
    class func fdkLatoBold14Font() -> UIFont {
        return UIFont(name: "Lato-Bold", size: 14.0) ?? UIFont.boldSystemFont(ofSize: 14)
    }
    
    class func fdkLatoBold12Font() -> UIFont {
        return UIFont(name: "Lato-Bold", size: 12.0) ?? UIFont.boldSystemFont(ofSize: 12)
    }
    
    class func fdkLatoLight10Font() -> UIFont {
        return UIFont(name: "Lato-Light", size: 10.0) ?? UIFont.systemFont(ofSize: 10)
    }
    
    class func fdkLatoSemiBold10Font() -> UIFont {
        return UIFont(name: "Lato-Semibold", size: 10.0) ?? UIFont.systemFont(ofSize: 10)
    }    
}
