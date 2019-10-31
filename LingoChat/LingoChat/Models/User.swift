// Project: LingoChat
//
// Created on Thursday, April 11, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import Foundation
import JWTHandler

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
    class Public: NSObject, Codable, JWTClaimRepresentable {
		// MARK: - JWTClaimRepresentable
		
		var aud: [String]?
		var iss: String?
		var sub: String?
		var jti: String?
		var exp: Date?
		var nbf: Date?
		var iat: Date?
		
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
			
			case aud
			case iss
			case sub
			case jti
			case exp
			case nbf
			case iat
        }
                
		required init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try values.decode(String.self, forKey: .id)
            self.email = try values.decode(String.self, forKey: .email)
            self.firstName = try values.decode(String.self, forKey: .firstName)
            self.lastName = try values.decode(String.self, forKey: .lastName)
            
            self.username = try values.decodeIfPresent(String.self, forKey: .username)
            self.photoUrl = try values.decodeIfPresent(String.self, forKey: .photoUrl)
            self.friendCount = try values.decodeIfPresent(Int.self, forKey: .friendCount)
			
			self.aud = try values.decodeIfPresent([String].self, forKey: .aud)
			self.iss = try values.decodeIfPresent(String.self, forKey: .iss)
			self.sub = try values.decodeIfPresent(String.self, forKey: .sub)
			self.jti = try values.decodeIfPresent(String.self, forKey: .jti)
			self.exp = try values.decodeIfPresent(Date.self, forKey: .exp)
			self.nbf = try values.decodeIfPresent(Date.self, forKey: .nbf)
			self.iat = try values.decodeIfPresent(Date.self, forKey: .iat)
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
