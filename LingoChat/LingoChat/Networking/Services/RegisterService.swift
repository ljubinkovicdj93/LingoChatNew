// Project: LingoChat
//
// Created on Monday, April 15, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import Foundation
import Alamofire

class RegisterService: NetworkService {
    func execute(parameters: Parameters = [:], networkRouter: NetworkRouter.RegisterRouter, with completionHandler: @escaping ((Result<User.Public>) -> Void)) {        
        sendNetworkRequest(networkRouter.create(parameters: parameters)) { result in
            switch result {
            case .success(let user):
                completionHandler(.success(user))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
