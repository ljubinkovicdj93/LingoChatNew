// Project: LingoChat
//
// Created on Saturday, March 23, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import UIKit

protocol RegisterControllerDelegate: class {
    func registerControllerDidPressRegister(_ viewController: RegisterController)
    func registerControllerDidPressCancel(_ viewController: RegisterController)
}

class RegisterController: UIViewController {
    
    // MARK: - Instance Properties
    weak var delegate: RegisterControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    @IBAction func registerTapped(_ sender: Any) {
        delegate?.registerControllerDidPressRegister(self)
    }
    
    @IBAction func goBackTapped(_ sender: Any) {
        delegate?.registerControllerDidPressCancel(self)
    }
}

extension RegisterController {
    class func instantiate(delegate: RegisterControllerDelegate) -> RegisterController {
        let registerController: RegisterController = UIStoryboard.instantiateViewController(fromStoryboard: .auth)
        registerController.delegate = delegate
        return registerController
    }
}

