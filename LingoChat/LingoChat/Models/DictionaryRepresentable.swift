// Project: LingoChat
//
// Created on Monday, April 15, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import Foundation

protocol DictionaryRepresentable {
    func toDict() -> [String: Any]
}

extension DictionaryRepresentable {
    func toDict() -> [String: Any] {
        var dict = [String: Any]()
        let otherSelf = Mirror(reflecting: self)
        otherSelf.children.forEach {
            if let key = $0.label {
                dict[key] = $0.value
            }
        }
        return dict
    }
}
