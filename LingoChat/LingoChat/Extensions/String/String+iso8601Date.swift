// Project: LingoChat
//
// Created on Sunday, April 21, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import Foundation

extension String {
    var iso8601: Date? {
        return ISO8601DateFormatter().date(from: self)
    }
}
