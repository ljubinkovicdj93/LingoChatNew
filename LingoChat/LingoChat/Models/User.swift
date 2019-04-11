// Project: LingoChat
//
// Created on Thursday, April 11, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import Foundation

struct User: Codable {
    let id: UUID
    var firstName: String
    var lastName: String
    var email: String
    var password: String
    var username: String?
    var photoUrl: String?
    var friendCount: Int = 0
    
    var fullName: String {
        guard !firstName.isEmpty, !lastName.isEmpty else { return "" }
        return "\(firstName) + \(lastName)"
    }
}
