// Project: LingoChat
//
// Created on Tuesday, April 23, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import Alamofire

enum NetworkError: Error {
    case authenticationError
    case noData
    case unableToDecode
    case outdated
    case badRequest
    case failed
}

extension DataResponse {
    func handleNetworkResponse<Model: Decodable>(type: Model.Type, _ response: DataResponse<Any>) -> Result<Model> {
        guard let statusCode = response.response?.statusCode else { return .failure(NSError.init()) }
        guard let _ = response.data else { return .failure(NetworkError.noData) }
        
        switch statusCode {
        case 200...299:
            let decoder = JSONDecoder()
            let result: Result<Model> = decoder.decodeResponse(type, from: response)
            
            switch result {
            case .success(let object):
                return .success(object)
            case .failure(let error):
                return .failure(error)
            }
        case 401...500: return .failure(NetworkError.authenticationError)
        case 501...599: return .failure(NetworkError.badRequest)
        case 600: return .failure(NetworkError.outdated)
        default: return .failure(NetworkError.failed)
        }
    }
}
