//
//  Style.swift
//  MasaMoney
//
//  Created by Maria Lopez on 12/05/2018.
//  Copyright © 2018 Maria Lopez. All rights reserved.
//

import UIKit

import UIKit

// MARK: - Colors
extension UIColor {
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
    
    // Roboto
    class func fdkRobotoCondensedBold24Font() -> UIFont {
        return UIFont(name: "RobotoCondensed-Bold", size: 24.0) ?? UIFont.boldSystemFont(ofSize: 24)
    }
    
    class func fdkRobotoCondensedBold22Font() -> UIFont {
        return UIFont(name: "RobotoCondensed-Bold", size: 22.0) ?? UIFont.boldSystemFont(ofSize: 22)
    }
    
    class func fdkRobotoCondensedBold16Font() -> UIFont {
        return UIFont(name: "RobotoCondensed-Bold", size: 16.0) ?? UIFont.boldSystemFont(ofSize: 16)
    }
    
    class func fdkRobotoCondensedBold30Font() -> UIFont {
        return UIFont(name: "RobotoCondensed-Bold", size: 30.0) ?? UIFont.boldSystemFont(ofSize: 30)
    }
    
    class func fdkRobotoCondensedBold20Font() -> UIFont {
        return UIFont(name: "RobotoCondensed-Bold", size: 20.0) ?? UIFont.boldSystemFont(ofSize: 20)
    }
    
    class func fdkRobotoCondensedBold10Font() -> UIFont {
        return UIFont(name: "RobotoCondensed-Bold", size: 10.0) ?? UIFont.boldSystemFont(ofSize: 10)
    }
    
    class func fdkRobotoCondensedBoldFont(size: CGFloat) -> UIFont {
        return UIFont(name: "RobotoCondensed-Bold", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
    
    class func fdkRobotoCondensedBold12Font() -> UIFont {
        return UIFont(name: "RobotoCondensed-Bold", size: 12.0) ?? UIFont.boldSystemFont(ofSize: 12)
    }
    
    class func fdkRobotoCondensedBold14Font() -> UIFont {
        return UIFont(name: "RobotoCondensed-Bold", size: 14.0) ?? UIFont.boldSystemFont(ofSize: 14)
    }
    
    class func fdkRobotoCondensedBold9Font() -> UIFont {
        return UIFont(name: "RobotoCondensed-Bold", size: 9.0) ?? UIFont.boldSystemFont(ofSize: 9)
    }
    
    class func fdkRobotoBold12Font() -> UIFont {
        return UIFont(name: "Roboto-Bold", size: 12.0) ?? UIFont.boldSystemFont(ofSize: 12)
    }
    
    class func fdkRobotoBold10Font() -> UIFont {
        return UIFont(name: "Roboto-Bold", size: 10.0) ?? UIFont.boldSystemFont(ofSize: 10)
    }
    
    class func fdkRobotoLight12Font() -> UIFont {
        return UIFont(name: "Roboto-Light", size: 12.0) ?? UIFont.systemFont(ofSize: 12)
    }
}
