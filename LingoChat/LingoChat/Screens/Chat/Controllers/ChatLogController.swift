// Project: LingoChat
//
// Created on Sunday, March 24, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import UIKit
import MessageKit

private let reuseIdentifier = "Cell"

protocol ChatLogControllerDelegate: class {
    func chatLogControllerDidPressSendMessage(_ viewController: ChatLogController)
}

class ChatLogController: MessagesViewController {

    weak var delegate: ChatLogControllerDelegate?
    
    var chatDetails: Chat!
    var messages: [Message] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.messagesCollectionView.reloadData()
            }
        }
    }
    
    lazy var user = User(email: "djole@gmail.com",
                         password: "Djole1993!",
                         firstName: "Djordje",
                         lastName: "Ljubinkovic",
                         username: "Le Djo")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        title = chatDetails.title
        
        ChatService.getAllMessages(for: chatDetails) { result in
            switch result {
            case .success(let messages):
                self.messages = messages
            case .failure(let error):
                print("LE ERROR:", error.localizedDescription)
            }
        }
        
        print("INSIDE USER CHAT LOG")
    }
    
    private func setDelegates() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        let testMessage = Message(text: "Lorem ipsum dolor sit amet...",
//                                  sender: Sender(id: user.email, displayName: user.fullName ?? user.username),
//                                  messageId: UUID().uuidString,
//                                  date: Date())
//        insertNewMessage(testMessage)
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.chatLogControllerDidPressSendMessage(self)
    }
    
    // MARK: - Helper methods
    private func insertNewMessage(_ message: Message) {
        let containsMessage = messages.contains { $0 == message }
        guard !containsMessage else { return }
        
        messages.append(message)
        messages.sort {
            $0.sentDate < $1.sentDate
        }
        
        let isLatestMsg = messages.lastIndex(of: message) == (messages.count - 1)
//        let shouldScrollToBottom = messagesCollectionView.isAtBottom && isLatestMsg
        
        messagesCollectionView.reloadData()
        
//        if shouldScrollToBottom {
        if isLatestMsg {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
    }
}

extension ChatLogController {
    class func instantiate(delegate: ChatLogControllerDelegate) -> ChatLogController {
        let chatLogController = ChatLogController.controller(from: .chat)
        chatLogController.delegate = delegate
        return chatLogController
    }
}

extension ChatLogController: MessagesDataSource {
    func currentSender() -> Sender {
//        let sender = Sender(id: "any_unique_id", displayName: "Steven")
//        return sender
        guard let currentUser = AuthManager.shared.currentUser,
            let currentUserId = currentUser.id
            else { return Sender(id: "-1", displayName: "-1") }
        
        return Sender(id: currentUserId,
                      displayName: currentUser.username ?? currentUser.fullName ?? currentUser.email ?? "")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        let message = messages[indexPath.section]
        
        return message
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
}

extension ChatLogController: MessagesDisplayDelegate {
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .red : .blue
    }
}

extension ChatLogController: MessagesLayoutDelegate {}
