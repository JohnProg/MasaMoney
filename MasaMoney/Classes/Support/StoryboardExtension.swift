//
//  StoryBoardExtension.swift
//  MasaMoney
//
//  Created by Maria Lopez on 13/05/2018.
//  Copyright © 2018 Maria Lopez. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    
    enum Storyboard: String {
        case Main
        case AddIncome
        case IncomeCalculator
        case Movement
    }
    
    convenience init(_ storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.rawValue, bundle: bundle)
    }
    
    func instantiateViewController<T: UIViewController>() -> T where T: StoryboardIdentifiable {
        let optionalViewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier)
        
        guard let viewController = optionalViewController as? T else {
            fatalError("Couldn’t instantiate view controller with identifier \(T.storyboardIdentifier) ")
        }
        
        return viewController
    }
}

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

extension UIViewController : StoryboardIdentifiable { }
