// Project: LingoChat
//
// Created on Saturday, March 23, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import UIKit
import Alamofire

class AuthenticationCoordinator: Coordinator {
    // MARK: - Properties
    var children: [Coordinator] = []
    var router: Router
    
    // MARK: - Initialization
    init(router: Router) {
        self.router = router
    }
    
    // MARK: - Coordinator methods
    func present(animated: Bool, onDismissed: (() -> Void)?) {
        let loginController = LoginController.instantiate(delegate: self)
        router.present(loginController)
    }
    
    private func presentChatCoordinator(parent: UIViewController) {
        let router = ModalNavigationRouter(parentViewController: parent)
        let coordinator = ChatCoordinator(router: router)
        self.presentChild(coordinator, animated: true)
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
extension AuthenticationCoordinator: LoginControllerDelegate {
    func loginControllerDidPressLogIn(_ viewController: LoginController, with credentials: User.Credentials) {
        print("Login tapped")
        LoginService.login(credentials: credentials) { result in
            switch result {
            case .success(let token):
                self.presentChatCoordinator(parent: viewController)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func loginControllerDidPressRegister(_ viewController: LoginController) {
        print("Register tapped")
        presentRegisterController()
    }
}

// MARK: - RegisterControllerDelegate
extension AuthenticationCoordinator: RegisterControllerDelegate {
    func registerControllerDidPressRegister(_ viewController: RegisterController, with userData: User) {
        RegisterService.register(user: userData) { result in
            switch result {
            case .success(let userPublic):
                self.presentChatCoordinator(parent: viewController)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func registerControllerDidPressCancel(_ viewController: RegisterController) {
        print("I think I'm going back...")
        presentLoginController()
    }
}
