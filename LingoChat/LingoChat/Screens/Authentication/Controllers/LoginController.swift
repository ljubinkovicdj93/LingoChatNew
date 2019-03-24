// Project: LingoChat
//
// Created on Friday, March 22, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import UIKit

protocol LoginControllerDelegate: class {
    func loginControllerDidPressLogIn(_ viewController: LoginController)
    func loginControllerDidPressRegister(_ viewController: LoginController)
}

class LoginController: UIViewController {
    
    // MARK: - Instance Properties
    weak var delegate: LoginControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    @IBAction func loginTapped(_ sender: Any) {
        delegate?.loginControllerDidPressLogIn(self)
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        delegate?.loginControllerDidPressRegister(self)
    }
}

extension LoginController {
    class func instantiate(delegate: LoginControllerDelegate) -> LoginController {
        let loginController: LoginController = UIStoryboard.instantiateViewController(fromStoryboard: .auth)
        loginController.delegate = delegate
        return loginController
    }
}
