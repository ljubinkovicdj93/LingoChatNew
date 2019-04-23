// Project: LingoChat
//
// Created on Saturday, March 23, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import UIKit
import Bond
import ReactiveKit

protocol RegisterControllerDelegate: class {
    func registerControllerDidPressRegister(_ viewController: RegisterController, with userData: User)
    func registerControllerDidPressCancel(_ viewController: RegisterController)
}

class RegisterController: UIViewController {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    // MARK: - Instance Properties
    weak var delegate: RegisterControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObservers()
    }
    
    private func addObservers() {
        combineLatest(firstNameTextField.reactive.text,
                      lastNameTextField.reactive.text,
                      usernameTextField.reactive.text,
                      emailTextField.reactive.text,
                      passwordTextField.reactive.text) { [weak self] (firstName, lastName, username, email, password) -> Bool in
            guard let self = self else { return false }
            return self.isTextFieldNonEmpty(firstName)
                && self.isTextFieldNonEmpty(lastName)
                && self.isTextFieldNonEmpty(username)
                && self.isValidEmail(email)
                && self.isValidPassword(password)
            }
            .bind(to: registerButton.reactive.isEnabled)
    }
    
    // MARK: - Actions
    @IBAction func registerTapped(_ sender: Any) {
        guard let firstName = firstNameTextField.text,
            let lastName = lastNameTextField.text,
            let username = usernameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text
        else { return }
        
        let user = User(firstName: firstName,
                        lastName: lastName,
                        email: email,
                        password: password,
                        username: username)
        delegate?.registerControllerDidPressRegister(self, with: user)
    }
    
    @IBAction func goBackTapped(_ sender: Any) {
        delegate?.registerControllerDidPressCancel(self)
    }
}

extension RegisterController: FieldValidationRepresentable {}

extension RegisterController {
    class func instantiate(delegate: RegisterControllerDelegate) -> RegisterController {
        let registerController = RegisterController.controller(from: .auth)
        registerController.delegate = delegate
        return registerController
    }
}

