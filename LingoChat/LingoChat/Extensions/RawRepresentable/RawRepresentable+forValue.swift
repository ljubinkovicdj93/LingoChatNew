// Project: LingoChat
//
// Created on Monday, May 06, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import Foundation

extension RawRepresentable {
    static func forValue(_ value: RawValue) -> Self {
        guard let type = Self.init(rawValue: value) else {
            fatalError("Could not instantiate a \(Self.self) with value \(value)")
        }
        
        return type
    }
}
