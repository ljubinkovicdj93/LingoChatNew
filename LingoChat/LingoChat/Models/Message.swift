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
 let parameters = [
 [
 "name": "languageID",
 "value": "1"
 ],
 [
 "name": "userChatID",
 "value": "08170ACD-0907-4100-B574-43E90D6DD7AE"
 ],
 [
 "name": "userLanguageID",
 "value": "08170ACD-0907-4100-B574-43E90D6DD7AE"
 ],
 [
 "name": "messageText",
 "value": "I'm good, you?"
 ],
 [
 "name": "translatedMessageText",
 "value": "Dobro sam, ti?"
 ],
 [
 "name": "messageType",
 "value": "0"
 ],
 [
 "name": "isTranslated",
 "value": "false"
 ],
 [
 "name": "createdAt",
 "value": "1554637159"
 ]
 ]
 */

struct Message {
    var languageID: String?
    var userChatID: UUID?
    var userLanguageID: UUID?
    var messageText: String?
    var translatedMessageText: String?
    var isTranslated: Bool?
    
    var messageId: String
    var sender: Sender
    var sentDate: Date // createdAt (from BE)
    var kind: MessageKind // messageType (from BE)
}

extension Message: Equatable {
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.messageId == rhs.messageId
    }
}

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
