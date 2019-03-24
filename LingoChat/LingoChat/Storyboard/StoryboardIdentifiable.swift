// Project: LingoChat
//
// Created on Friday, March 22, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import UIKit

extension UIStoryboard {
    enum Storyboard: String {
        case auth // contains login and register (authentication flow)
        case chat // contains user chat list and chat log controllers
        
        var filename: String {
            return rawValue.capitalized
        }
    }
    
    class func storyboard(_ storyboard: Storyboard, bundle: Bundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: storyboard.filename, bundle: bundle)
    }
    
    class func instantiateViewController<VC: UIViewController>(fromStoryboard: Storyboard) -> VC {
        let storyboard = UIStoryboard.storyboard(fromStoryboard)
        let viewController: VC = storyboard.instantiateViewController()
        return viewController
    }
    
    private func instantiateViewController<VC: UIViewController>() -> VC {
        guard let vc = self.instantiateViewController(withIdentifier: VC.storyboardIdentifier) as? VC else {
            fatalError("Couldn't instantiate view controller with identifier \(VC.storyboardIdentifier) ")
        }
        return vc
    }
}

protocol StoryboardIdentifiable: class {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

extension UIViewController: StoryboardIdentifiable {}
