// Project: LingoChat
//
// Created on Sunday, March 24, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import UIKit
import JWTDecode

class ChatCoordinator: Coordinator {
    // MARK: - Properties
    let token: Token
    
    var children: [Coordinator] = []
    var router: Router
    
    // MARK: - Initialization
    init(router: Router, token: Token) {
        self.router = router
        self.token = token
    }
    
    // MARK: - Coordinator methods
    func present(animated: Bool, onDismissed: (() -> Void)?) {
        let userChatListController = UserChatListController.instantiate(delegate: self)
        userChatListController.token = token
        router.present(userChatListController)
    }
}

// MARK: - UserChatListControllerDelegate
extension ChatCoordinator: UserChatListControllerDelegate {
    func userChatListControllerDidSelectChatItem(_ viewController: UserChatListController, at indexPath: IndexPath) {
        let userChats = viewController.userChats
        guard userChats.count > 0 else { return }
        
        let chat = userChats[indexPath.row]
        
        print("Selected item at row: \(chat)")
        presentChatLogController(chat: chat)
    }
    
    private func presentChatLogController(chat: Chat) {
        let chatLogController = ChatLogController.instantiate(delegate: self)
        chatLogController.chatDetails = chat
        router.present(chatLogController)
    }
}

// MARK: - ChatLogControllerDelegate
extension ChatCoordinator: ChatLogControllerDelegate {
    func chatLogControllerDidPressSendMessage(_ viewController: ChatLogController) {
        print("press...")
    }
}
