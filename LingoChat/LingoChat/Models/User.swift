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
        var username: String?
        var firstName: String
        var lastName: String
        var photoUrl: String?
        var friendCount: Int?
        
        enum CodingKeys: String, CodingKey {
            case id
            case email
            case username
            case firstName
            case lastName
            case photoUrl
            case friendCount
        }
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try values.decode(UUID.self, forKey: .id)
            self.email = try values.decode(String.self, forKey: .email)
            self.firstName = try values.decode(String.self, forKey: .firstName)
            self.lastName = try values.decode(String.self, forKey: .lastName)
            
            self.username = try values.decodeIfPresent(String.self, forKey: .username)
            self.photoUrl = try values.decodeIfPresent(String.self, forKey: .photoUrl)
            self.friendCount = try values.decodeIfPresent(Int.self, forKey: .friendCount)
        }
    }
    
    struct Credentials: Encodable {
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
