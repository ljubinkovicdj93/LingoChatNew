// Project: LingoChat
//
// Created on Monday, April 15, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import Foundation
import Alamofire

final class RegisterService {
    static func register(user: User, with completionHandler: @escaping (Result<Token>) -> Void) {
        do {
            let userDictionary = try user.asDictionary()
            let registerRequest = NetworkRouter.RegisterRouter.create(parameters: userDictionary)
            NetworkRouter.sendRequest(registerRequest) { (result: Result<Token>) in
                switch result {
                case .success(let token):
                    print("token:", token)
					LCKeychain.shared[.token] = token.jwtString
					
					do {
						try AuthManager.shared.setCurrentUser(jwtString: token.jwtString)
					} catch {
						print(error)
					}
					
                    completionHandler(.success(token))
                case .failure(let error):
                    print("error:", error.localizedDescription)
                    completionHandler(.failure(error))
                }
            }
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
}
