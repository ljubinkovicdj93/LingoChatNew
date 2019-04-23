// Project: LingoChat
//
// Created on Friday, April 12, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import Foundation
import Alamofire

class LoginService: NetworkService {
    func execute(parameters: Parameters = [:], networkRouter: NetworkRouter.LoginRouter, with completionHandler: @escaping ((Result<Token>) -> Void)) {
        guard let email = parameters["email"] as? String,
            let password = parameters["password"] as? String else {
            fatalError("No email and/or password found in parameters!")
        }
        
        let userCredentials = User.Credentials.init(email: email, password: password)
        
        guard let base64Credentials = userCredentials.base64EncodedCredentials else {
            completionHandler(.failure(NetworkError.failed))
            return
        }
        
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        
        sendNetworkRequest(networkRouter.create(headers: headers)) { result in
            switch result {
            case .success(let token):
                completionHandler(.success(token))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
