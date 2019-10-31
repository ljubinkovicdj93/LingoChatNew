// Project: LingoChat
//
// Created on Tuesday, April 23, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import UIKit

extension UIViewController: StoryboardIdentifiable {}

extension UIViewController {
    private class func instantiateController<T: UIViewController>(from storyboard: UIStoryboard.Storyboard) -> T {
        let vc: T = UIStoryboard.instantiateViewController(fromStoryboard: storyboard)
        return vc
    }
    
    class func controller(from storyboard: UIStoryboard.Storyboard) -> Self {
        return UIViewController.instantiateController(from: storyboard)
    }
}
