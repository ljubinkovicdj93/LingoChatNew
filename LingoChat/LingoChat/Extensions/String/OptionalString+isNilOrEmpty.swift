// Project: LingoChat
//
// Created on Monday, April 15, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import Foundation

extension Optional where Wrapped == String {
    func isNilOrEmpty() -> Bool {
        return self?.isEmpty ?? true
    }
}
