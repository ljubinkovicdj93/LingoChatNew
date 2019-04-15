// Project: LingoChat
//
// Created on Thursday, April 11, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import Foundation

struct Token: Codable {
    let id: UUID
    var token: String
    var userID: String
}
