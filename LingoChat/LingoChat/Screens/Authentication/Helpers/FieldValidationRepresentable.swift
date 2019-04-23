// Project: LingoChat
//
// Created on Thursday, April 11, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import Foundation

protocol FieldValidationRepresentable {
    func isTextFieldNonEmpty(_ textFieldText: String?) -> Bool
    func isValidPassword(_ passwordText: String?) -> Bool
    func isValidEmail(_ emailAddress: String?) -> Bool
}

extension FieldValidationRepresentable {
    func isTextFieldNonEmpty(_ textFieldText: String?) -> Bool {
        guard let text = textFieldText else { return false }
        return text.count > 0
    }
    
    func isValidEmail(_ emailAddress: String?) -> Bool {
        guard let email = emailAddress else { return false }
        
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: email)
    }
    
    func isValidPassword(_ passwordText: String?) -> Bool {
        guard let password = passwordText else { return false }
        
        // at least one uppercase,
        // at least one digit
        // at least one lowercase
        // 8 characters total
        let pred = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        return pred.evaluate(with: password)
    }
}
