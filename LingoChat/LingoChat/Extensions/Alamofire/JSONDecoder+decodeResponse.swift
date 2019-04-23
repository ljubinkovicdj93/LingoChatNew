// Project: LingoChat
//
// Created on Friday, April 12, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import Foundation
import Alamofire

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
