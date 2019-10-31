// Project: LingoChat
//
// Created on Tuesday, April 23, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import MessageKit
import CoreLocation

private struct CoordinateItem: LocationItem {
    var location: CLLocation
    var size: CGSize
    
    init(location: CLLocation) {
        self.location = location
        self.size = CGSize(width: 240, height: 240)
    }
}

private struct ImageMediaItem: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
    
    init(image: UIImage) {
        self.image = image
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
    }
}

/*
     {
         "id": "01F766CD-5891-4564-BEDF-590B34A751FE",
         "userLanguageID": "8752FAF7-1DA3-4B95-A7A2-1FD29D2A368C",
         "isTranslated": false,
         "translatedMessageText": "Dobro sam, ti?",
         "userChatID": "34E6E9C0-FF6F-481B-A3E4-30275335446E",
         "messageText": "I'm good, you?",
         "messageType": 0,
         "createdAt": "2050-04-07T11:39:19Z"
     }
 */
struct Message: Codable {
    // MARK: - Custom Properties
    var userLanguageID: String?
    var isTranslated: Bool?
    var translatedMessageText: String?
    var userChatID: String?
    var messageText: String?
    var languageID: String?
    
    // MARK: - MessageType Properties
    var messageId: String
    
    #warning("TODO: MUST CREATE USER_ID FOREIGN KEY INSIDE MESSAGE ENTITY")
    var sender: Sender
    var sentDate: Date // createdAt (from BE)
    var kind: MessageKind // messageType (from BE)
    
    enum CodingKeys: String, CodingKey {
        case messageId = "id"
        case userLanguageID
        case isTranslated
        case translatedMessageText
        case userChatID
        case messageText
        case languageID
//        case kind = "messageType"
        case sentDate = "createdAt"
    }
    
    // MARK: - Initialization
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.messageId = try values.decode(String.self, forKey: .messageId)
        self.userLanguageID = try values.decode(String.self, forKey: .userLanguageID)
        self.isTranslated = try values.decode(Bool.self, forKey: .isTranslated)
        self.translatedMessageText = try values.decode(String.self, forKey: .translatedMessageText)
        
        self.userChatID = try values.decodeIfPresent(String.self, forKey: .userChatID)
        self.messageText = try values.decodeIfPresent(String.self, forKey: .messageText)
        self.languageID = try values.decodeIfPresent(String.self, forKey: .languageID)
        
//        self.kind = try values.decodeIfPresent(MessageKind.self, forKey: .kind)
        let createdAtString = try values.decode(String.self, forKey: .sentDate)
        
        if let createdAtDate = createdAtString.iso8601 {
            self.sentDate = createdAtDate
        } else {
            self.sentDate = Date()
        }

        #warning("TODO: REFACTOR!")
        self.kind = MessageKind.text(self.messageText!)
        self.sender = Sender(id: userLanguageID!, displayName: sentDate.description)
    }
    
    // MARK: - Encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.messageId, forKey: .messageId)
        
        try container.encode(self.messageId, forKey: .messageId)
        try container.encode(self.userLanguageID, forKey: .userLanguageID)
        try container.encode(self.isTranslated, forKey: .isTranslated)
        try container.encode(self.translatedMessageText, forKey: .translatedMessageText)
        
        try container.encode(self.userChatID, forKey: .userChatID)
        try container.encode(self.messageText, forKey: .messageText)
        try container.encode(self.languageID, forKey: .languageID)
        
//        try container.encode(self.kind, forKey: .kind)
        try container.encode(self.sentDate, forKey: .sentDate)
    }
}

// MARK: - Equatable
extension Message: Equatable {
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.messageId == rhs.messageId
    }
}

// MARK: - MessageType
extension Message: MessageType {
    private init(kind: MessageKind, sender: Sender, messageId: String, date: Date) {
        self.kind = kind
        self.sender = sender
        self.messageId = messageId
        self.sentDate = date
    }
    
    init(custom: Any?, sender: Sender, messageId: String, date: Date) {
        self.init(kind: .custom(custom), sender: sender, messageId: messageId, date: date)
    }
    
    init(text: String, sender: Sender, messageId: String, date: Date) {
        self.init(kind: .text(text), sender: sender, messageId: messageId, date: date)
    }
    
    init(attributedText: NSAttributedString, sender: Sender, messageId: String, date: Date) {
        self.init(kind: .attributedText(attributedText), sender: sender, messageId: messageId, date: date)
    }
    
    init(image: UIImage, sender: Sender, messageId: String, date: Date) {
        let mediaItem = ImageMediaItem(image: image)
        self.init(kind: .photo(mediaItem), sender: sender, messageId: messageId, date: date)
    }
    
    init(thumbnail: UIImage, sender: Sender, messageId: String, date: Date) {
        let mediaItem = ImageMediaItem(image: thumbnail)
        self.init(kind: .video(mediaItem), sender: sender, messageId: messageId, date: date)
    }
    
    init(location: CLLocation, sender: Sender, messageId: String, date: Date) {
        let locationItem = CoordinateItem(location: location)
        self.init(kind: .location(locationItem), sender: sender, messageId: messageId, date: date)
    }
    
    init(emoji: String, sender: Sender, messageId: String, date: Date) {
        self.init(kind: .emoji(emoji), sender: sender, messageId: messageId, date: date)
    }
}
