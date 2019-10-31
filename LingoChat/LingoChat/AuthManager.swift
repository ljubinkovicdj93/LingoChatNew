// Project: LingoChat
//
// Created on Saturday, April 27, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import Foundation
import JWTHandler

final class JWTManager: JWTTokenHandleProtocol {	
	var jwtToken: JWTToken<User.Public>?
	
	private init() {}
	
	static let shared = JWTManager.init()
}

class AuthManager {
	static let shared = AuthManager()

	private var currentUser: User.Public?

	private init() {}
	
    func setCurrentUser(jwtString: String) throws {
        do {
			var jwtTokenManager = JWTManager.shared
			try jwtTokenManager.decodeJWT(jwtString)
			guard let jwtToken = jwtTokenManager.jwtToken else { fatalError("JWTToken should not be nil!") }

			let publicUserDict = jwtToken.body
			
			print("GET_CLAIMS:\n")
			jwtToken.claims.forEach {
				print("CLAIM:", $0)
			}

			let claimInfo: Date? = jwtToken.getClaimValue(.exp) as? Date
			
			print("AUDIENCE: \(jwtToken.getClaimValue(.aud) as? [String])")
			print("ISSUER: \(jwtToken.getClaimValue(.iss) as? String)")
			print("SUBJECT: \(jwtToken.getClaimValue(.sub) as? String)")
			print("JWT_ID: \(jwtToken.getClaimValue(.jti) as? String)")
			print("EXPIRATION_DATE: \(jwtToken.getClaimValue(.exp) as? Date)")
			print("NOT_BEFORE_DATE: \(jwtToken.getClaimValue(.nbf) as? Date)")
			print("ISSUED_AT_DATE: \(jwtToken.getClaimValue(.iat) as? Date)")
			
            AuthManager.shared.currentUser = publicUserDict
        } catch {
            print(error.localizedDescription)
        }
    }
	
	func getCurrentUser() -> User.Public? {
		return self.currentUser
	}
}
