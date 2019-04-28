// Project: LingoChat
//
// Created on Friday, April 12, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import Foundation
import Alamofire

final class LoginService {
    static func login(credentials: User.Credentials, with completionHandler: @escaping (Result<Token>) -> Void) {
        guard let base64Credentials = credentials.base64EncodedCredentials else { return }
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        let loginRequest = NetworkRouter.LoginRouter.create(headers: headers)
        
        NetworkRouter.sendRequest(loginRequest) { (result: Result<Token>) in
            switch result {
            case .success(let token):
                print("token:", token)
                try? AuthManager.shared.setCurrentUser(jwtToken: token.token)
                completionHandler(.success(token))
            case .failure(let error):
                print("error:", error.localizedDescription)
                completionHandler(.failure(error))
            }
        }
    }
}
