// Project: LingoChat
//
// Created on Thursday, April 11, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import Foundation
import ObjectMapper

protocol FullNameRepresentable {
    var fullName: String? { get }
}

struct User: Codable {
    private(set) var id: UUID?
    var email: String?
    var password: String?
    var username: String?
    var firstName: String?
    var lastName: String?
    var photoUrl: URL?
    var friendCount: Int?
    
    var base64EncodedCredentials: String? {
        guard let userEmail = self.email,
            let userPassword = self.password
            else { return nil }
        
        guard let credentialData = "\(userEmail):\(userPassword)".data(using: String.Encoding.utf8) else {
            return nil
        }
        let base64Credentials = credentialData.base64EncodedString(options: [])
        return base64Credentials
    }
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    init(email: String, password: String, firstName: String, lastName: String, username: String, photoUrl: URL? = nil) {
        self.init(email: email, password: password)
        self.firstName = firstName.capitalized
        self.lastName = lastName.capitalized
        self.username = username
        self.photoUrl = photoUrl
    }
    
    /// Public representation of the User struct.
    /// Public is a class since we are caching it to get the current user.
    struct Public: Codable, Mappable {
        private(set) var id: String?
        var email: String?
        var username: String?
        var firstName: String?
        var lastName: String?
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
}

extension User: FullNameRepresentable {
    var fullName: String? {
        var fullNameArray = [String]()
        
        if !self.firstName.isNilOrEmpty() {
            fullNameArray.append(self.firstName!)
        }
        
        if !self.lastName.isNilOrEmpty() {
            fullNameArray.append(self.lastName!)
        }
        
        return fullNameArray.isEmpty ? nil : fullNameArray.joined(separator: " ")
    }
}

extension User.Public: FullNameRepresentable {
    var fullName: String? {
        var fullNameArray = [String]()
        
        if !self.firstName.isNilOrEmpty() {
            fullNameArray.append(self.firstName!)
        }
        
        if !self.lastName.isNilOrEmpty() {
            fullNameArray.append(self.lastName!)
        }
        
        return fullNameArray.isEmpty ? nil : fullNameArray.joined(separator: " ")
    }
}
