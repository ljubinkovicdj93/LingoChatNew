// Project: LingoChat
//
// Created on Saturday, April 27, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import Foundation
import JWTDecode
import ObjectMapper

class AuthManager {
    var currentUser: User.Public?
    
    func setCurrentUser(jwtToken: String) throws {
        do {
            let jwt = try decode(jwt: jwtToken)
            let publicUserDict = Mapper<User.Public>().map(JSON: jwt.body)
            
            AuthManager.shared.currentUser = publicUserDict
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static let shared = AuthManager()
    
    init() {}
}
