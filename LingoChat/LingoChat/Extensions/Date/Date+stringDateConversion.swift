// Project: LingoChat
//
// Created on Sunday, April 21, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import Foundation

extension Date {
    /// Returns a string representation for the date with the given formatter
    func string(with format: DateFormatter) -> String {
        return format.string(from: self)
    }
    
    /// Creates a `Date` from the given string and formatter. Nil if the string couldn't be parsed
    init?(string: String, formatter: DateFormatter) {
        guard let date = formatter.date(from: string) else { return nil }
        self.init(timeIntervalSince1970: date.timeIntervalSince1970)
    }
}
