// Project: LingoChat
//
// Created on Monday, April 15, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import Foundation

enum EncodingError: Error {
    case unableToConvertToDictionary
}

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
    
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw EncodingError.unableToConvertToDictionary
        }
        return dictionary
    }
}
