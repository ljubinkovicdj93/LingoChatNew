// Project: LingoChat
//
// Created on Saturday, March 23, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import UIKit
import Bond
import ReactiveKit

protocol RegisterControllerDelegate: class {
    func registerControllerDidPressRegister(_ viewController: RegisterController)
    func registerControllerDidPressCancel(_ viewController: RegisterController)
}

class RegisterController: UIViewController {
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
        combineLatest(usernameTextField.reactive.text,
                      emailTextField.reactive.text,
                      passwordTextField.reactive.text) { [weak self] (username, email, password) -> Bool in
            guard let self = self else { return false }
            return self.isValidUsername(username) && self.isValidEmail(email) && self.isValidPassword(password)
            }
            .bind(to: registerButton.reactive.isEnabled)
    }
    
    // MARK: - Actions
    @IBAction func registerTapped(_ sender: Any) {
        delegate?.registerControllerDidPressRegister(self)
    }
    
    @IBAction func goBackTapped(_ sender: Any) {
        delegate?.registerControllerDidPressCancel(self)
    }
}

extension RegisterController: FieldValidationRepresentable {
    func isValidUsername(_ usernameText: String?) -> Bool {
        guard let username = usernameText else { return false }
        return username.count > 0
    }
}

extension RegisterController {
    class func instantiate(delegate: RegisterControllerDelegate) -> RegisterController {
        let registerController: RegisterController = UIStoryboard.instantiateViewController(fromStoryboard: .auth)
        registerController.delegate = delegate
        return registerController
    }
}

