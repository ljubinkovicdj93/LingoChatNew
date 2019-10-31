// Project: LingoChat
//
// Created on Saturday, March 23, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import UIKit

public class AppDelegateRouter: Router {
    // MARK: - Instance Properties
    public let window: UIWindow
    
    // MARK: - Object Lifecycle
    public init(window: UIWindow) {
        self.window = window
    }
    
    // MARK: - Router
    public func present(_ viewController: UIViewController, animated: Bool, onDismissed: (() -> Void)?) {
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
    
    public func dismiss(animated: Bool) { /* Do nothing */ }
}
