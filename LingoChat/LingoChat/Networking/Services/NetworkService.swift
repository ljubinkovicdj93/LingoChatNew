// Project: LingoChat
//
// Created on Friday, April 12, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import Foundation
import Alamofire

enum NetworkError: Error {
    case authenticationError
    case noData
    case unableToDecode
    case outdated
    case badRequest
    case failed
}

protocol NetworkService {
    associatedtype NetworkRoutable: Routable
    associatedtype Model: Decodable
    
    func execute(parameters: Parameters, networkRouter: NetworkRoutable, with completionHandler: @escaping ((Result<Model>) -> Void))
    func sendNetworkRequest(_ req: RequestConverterProtocol, with completionHandler: @escaping ((Result<Model>) -> Void))
}

class AnyNetworkService<T: Decodable, U: Routable>: NetworkService {
    private let _execute: (_ parameters: Parameters, _ networkRouter: U, _ completionHandler: @escaping ((Result<T>) -> Void)) -> ()
    private let _sendNetworkRequest: (_ req: RequestConverterProtocol, _ completionHandler: @escaping ((Result<T>) -> Void)) -> ()

    init<NS: NetworkService>(_ networkService: NS) where NS.Model == T, NS.NetworkRoutable == U {
        self._sendNetworkRequest = networkService.sendNetworkRequest
        self._execute = networkService.execute
    }

    func sendNetworkRequest(_ req: RequestConverterProtocol, with completionHandler: @escaping ((Result<T>) -> Void)) {
        self._sendNetworkRequest(req, completionHandler)
    }
    
    func execute(parameters: Parameters, networkRouter: U, with completionHandler: @escaping ((Result<T>) -> Void)) {
        self._execute(parameters, networkRouter, completionHandler)
    }
}

extension NetworkService {
    func handleNetworkResponse<Model: Decodable>(type: Model.Type, _ response: DataResponse<Any>) -> Result<Model> {
        guard let statusCode = response.response?.statusCode else { return .failure(NSError.init()) }
        switch statusCode {
        case 200...299:
            switch self.decode(response, decodingType: Model.self) {
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
    
    func sendNetworkRequest(_ req: RequestConverterProtocol, with completionHandler: @escaping ((Result<Model>) -> Void)) {
        Alamofire.request(req).responseJSON { response in

            switch self.handleNetworkResponse(type: Model.self, response) {
            case .success(let object):
                completionHandler(.success(object))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}

extension NetworkService {
    private func decode<Model: Decodable>(_ response: DataResponse<Any>, decodingType: Model.Type) -> Result<Model> {
        guard let _ = response.data else { return .failure(NetworkError.noData) }
        
        let decoder = JSONDecoder()
        let model: Result<Model> = decoder.decodeResponse(decodingType, from: response)
        return model
    }
}

extension JSONDecoder {
    func decodeResponse<Model: Decodable>(_ type: Model.Type, from response: DataResponse<Any>) -> Result<Model> {
        guard response.error == nil else {
            print(response.error!)
            return .failure(response.error!)
        }
        
        guard let responseData = response.data else {
            print("didn't get any data from API")
            return .failure(NetworkError.unableToDecode)
        }
        
        do {
            let item = try decode(Model.self, from: responseData)
            return .success(item)
        } catch {
            print("error trying to decode response")
            print(error)
            return .failure(error)
        }
    }
}
