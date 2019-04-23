// Project: LingoChat
//
// Created on Sunday, April 21, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import Foundation

struct Chat: Codable {
    var id: UUID?
    var title: String
    var createdAt: Date
    var createdBy: UUID
    var languageID: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case title = "name"
        case createdAt
        case createdBy = "createdByUserID"
        case languageID
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(UUID.self, forKey: .id)
        self.title = try values.decode(String.self, forKey: .title)
        self.createdBy = try values.decode(UUID.self, forKey: .createdBy)
        self.languageID = try values.decode(Int.self, forKey: .languageID)
        
        let createdAtString = try values.decode(String.self, forKey: .createdAt)
        
        if let createdAtDate = createdAtString.iso8601 {
            self.createdAt = createdAtDate
        } else {
            self.createdAt = Date()
        }
    }
}
