// Project: LingoChat
//
// Created on Saturday, March 23, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import UIKit
import Alamofire

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
        self.presentChild(coordinator, animated: true)
    }
    
    private func loginUser(with credentials: (email: String, password: String), with completionHandler: @escaping (Result<String>) -> Void) {
        guard let credentialData = "\(credentials.email):\(credentials.password)".data(using: String.Encoding.utf8) else {
            completionHandler(.failure(NSError.init()))
            return
        }
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        
        Alamofire.request(NetworkRouter.LoginRouter.create(headers: headers)).validate().responseJSON { response in
            switch response.result {
            case .success:
                let decoder = JSONDecoder()
                do {
                    guard let tokenData = response.data else { completionHandler(.failure(NSError.init())); return }
                    let token = try decoder.decode(Token.self, from: tokenData)
                    debugPrint("LOGIN ROUTER SUCCESS:", token)
                    completionHandler(.success(token.token))
                } catch {
                    completionHandler(.failure(error))
                }
            case .failure(let error):
                print("LOGIN ROUTER ERROR:", error)
                completionHandler(.failure(error))
            }
        }
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
    func loginControllerDidPressLogIn(_ viewController: LoginController, with credentials: (email: String, password: String)) {
        print("Login tapped")
        loginUser(with: (email: credentials.email, password: credentials.password)) { [weak self] (result) in
            guard let self = self else { return }
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
