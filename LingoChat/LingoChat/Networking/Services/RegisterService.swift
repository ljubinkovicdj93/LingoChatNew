// Project: LingoChat
//
// Created on Monday, April 15, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import Foundation
import Alamofire

final class RegisterService {
    static func register(user: User, with completionHandler: @escaping (Result<User.Public>) -> Void) {
        do {
            let userDictionary = try user.asDictionary()
            let registerRequest = NetworkRouter.RegisterRouter.create(parameters: userDictionary)
            NetworkRouter.sendRequest(registerRequest) { (result: Result<User.Public>) in
                switch result {
                case .success(let userPublic):
                    print("userPublic:", userPublic)
                    completionHandler(.success(userPublic))
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
