// Project: LingoChat
//
// Created on Thursday, April 11, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import Foundation
import ObjectMapper

struct User: Codable {
    var id: UUID?
    var email: String
    var password: String
    var username: String
    var firstName: String
    var lastName: String
    var photoUrl: String?
    var friendCount: Int?
    
    var fullName: String? {
        guard !firstName.isEmpty && !lastName.isEmpty else { return nil }
        
        return "\(firstName.capitalized) \(lastName.capitalized)"
    }
    
    var credentials: User.Credentials {
        guard !self.email.isEmpty, !self.password.isEmpty else { fatalError("Cannot get credentials!") }
        return User.Credentials(email: self.email, password: self.password)
    }
    
    init(firstName: String, lastName: String, email: String, password: String, username: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.password = password
        self.username = username
    }
    
    /// Public representation of the User struct.
    /// Public is a class since we are caching it to get the current user.
    struct Public: Codable, Mappable {
        var id: String!
        var email: String!
        var username: String?
        var firstName: String!
        var lastName: String!
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
        
        init?(map: Map) {}
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try values.decode(String.self, forKey: .id)
            self.email = try values.decode(String.self, forKey: .email)
            self.firstName = try values.decode(String.self, forKey: .firstName)
            self.lastName = try values.decode(String.self, forKey: .lastName)
            
            self.username = try values.decodeIfPresent(String.self, forKey: .username)
            self.photoUrl = try values.decodeIfPresent(String.self, forKey: .photoUrl)
            self.friendCount = try values.decodeIfPresent(Int.self, forKey: .friendCount)
        }
        
        // MARK: - Mappable methods
        mutating func mapping(map: Map) {
            id <- map["id"]
            email <- map["email"]
            username <- map["username"]
            firstName <- map["firstName"]
            lastName <- map["lastName"]
            photoUrl <- map["photoUrl"]
            friendCount <- map["friendCount"]
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
