// Project: LingoChat
//
// Created on Saturday, March 23, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import UIKit

class AuthCoordinator: Coordinator {
    var children: [Coordinator] = []
    var router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    func present(animated: Bool, onDismissed: (() -> Void)?) {
        let loginController = LoginController.instantiate(delegate: self)
        router.present(loginController)
    }
    
    private func presentChatCoordinator(parent: UIViewController) {
        let router = ModalNavigationRouter(parentViewController: parent)
        let coordinator = ChatCoordinator(router: router)
        presentChild(coordinator, animated: true)
    }
    
    private func presentRegisterController() {
        let registerController = RegisterController.instantiate(delegate: self)
        router.present(registerController)
    }
    
    private func presentLoginController() {
        let loginController = LoginController.instantiate(delegate: self)
        router.present(loginController)
    }
}

// MARK: - LoginControllerDelegate
extension AuthCoordinator: LoginControllerDelegate {
    func loginControllerDidPressLogIn(_ viewController: LoginController) {
        print("Login tapped")
        presentChatCoordinator(parent: viewController)
    }
    
    func loginControllerDidPressRegister(_ viewController: LoginController) {
        print("Register tapped")
        presentRegisterController()
    }
}

// MARK: - RegisterControllerDelegate
extension AuthCoordinator: RegisterControllerDelegate {
    func registerControllerDidPressRegister(_ viewController: RegisterController) {
        print("registering...")
        presentChatCoordinator(parent: viewController)
    }
    
    func registerControllerDidPressCancel(_ viewController: RegisterController) {
        print("I think I'm going back...")
        presentLoginController()
    }
}
