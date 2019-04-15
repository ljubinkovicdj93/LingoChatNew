// Project: LingoChat
//
// Created on Saturday, March 23, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import UIKit
import Alamofire

class LoginCoordinator: Coordinator {
    var networkService: AnyNetworkService<Token, NetworkRouter.LoginRouter>?
    
    var children: [Coordinator] = []
    var router: Router
    
    init(router: Router, networkService: AnyNetworkService<Token, NetworkRouter.LoginRouter>? = nil) {
        self.router = router
        self.networkService = networkService
    }
    
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
extension LoginCoordinator: LoginControllerDelegate {
    func loginControllerDidPressLogIn(_ viewController: LoginController, with credentials: (email: String, password: String)) {
        guard let netService = self.networkService else { return }
        print("Login tapped")
        
        netService.execute(parameters: ["email": credentials.email, "password": credentials.password],
                           networkRouter: NetworkRouter.LoginRouter()) { (result: Result<Token>) in
                            switch result {
                            case .success(let token):
                                self.presentChatCoordinator(parent: viewController)
                                print("HERE IS MY TOKEN!", token)
                            case .failure(let error):
                                print("error:", error.localizedDescription)
                            }
        }
    }
    
    func loginControllerDidPressRegister(_ viewController: LoginController) {
        print("Register tapped")
        presentRegisterController()
    }
}

// MARK: - RegisterControllerDelegate
extension LoginCoordinator: RegisterControllerDelegate {
    func registerControllerDidPressRegister(_ viewController: RegisterController) {
        print("registering...")
        presentChatCoordinator(parent: viewController)
    }
    
    func registerControllerDidPressCancel(_ viewController: RegisterController) {
        print("I think I'm going back...")
        presentLoginController()
    }
}
