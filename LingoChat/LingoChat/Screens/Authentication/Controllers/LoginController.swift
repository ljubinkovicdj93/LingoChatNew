// Project: LingoChat
//
// Created on Friday, March 22, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import UIKit
import Bond
import ReactiveKit

protocol LoginControllerDelegate: class {
    func loginControllerDidPressLogIn(_ viewController: LoginController)
    func loginControllerDidPressRegister(_ viewController: LoginController)
}

class LoginController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - Instance Properties
    weak var delegate: LoginControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObservers()
    }
    
    private func addObservers() {
        combineLatest(emailTextField.reactive.text, passwordTextField.reactive.text) { [weak self] (email, password) -> Bool in
            guard let self = self else { return false }
            return self.isValidEmail(email) && self.isValidPassword(password)
            }
            .bind(to: loginButton.reactive.isEnabled)
    }

    // MARK: - Actions
    @IBAction func loginTapped(_ sender: Any) {
        delegate?.loginControllerDidPressLogIn(self)
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        delegate?.loginControllerDidPressRegister(self)
    }
}

extension LoginController: FieldValidationRepresentable {}

extension LoginController {
    class func instantiate(delegate: LoginControllerDelegate) -> LoginController {
        let loginController: LoginController = UIStoryboard.instantiateViewController(fromStoryboard: .auth)
        loginController.delegate = delegate
        return loginController
    }
}
