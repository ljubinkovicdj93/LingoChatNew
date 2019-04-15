// Project: LingoChat
//
// Created on Thursday, April 11, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import Foundation

struct User: Codable {
    var id: UUID?
    var email: String
    var password: String
    var username: String
    var firstName: String
    var lastName: String
    var photoUrl: String?
    var friendCount: Int?
    
    var fullName: String {
        guard !firstName.isEmpty, !lastName.isEmpty else { return "" }
        return "\(firstName) + \(lastName)"
    }
    
    init(firstName: String, lastName: String, email: String, password: String, username: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.password = password
        self.username = username
    }
    
    struct Public: Codable {
        let id: UUID
        var email: String
        var username: String
        var firstName: String
        var lastName: String
    }
    
    struct Credentials {
        var email: String
        var password: String
        
        var base64EncodedCredentials: String? {
            guard let credentialData = "\(self.email):\(self.password)".data(using: String.Encoding.utf8) else {
                return nil
            }
            let base64Credentials = credentialData.base64EncodedString(options: [])
            return base64Credentials
        }
    }
}
