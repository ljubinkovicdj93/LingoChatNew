// Project: LingoChat
//
// Created on Sunday, March 24, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import UIKit
import JWTDecode

class ChatCoordinator: Coordinator {
    // MARK: - Properties
    var children: [Coordinator] = []
    var router: Router
    
    let token: Token
    
    // MARK: - Initialization
    init(router: Router, token: Token) {
        self.router = router
        self.token = token
    }
    
    // MARK: - Coordinator methods
    func present(animated: Bool, onDismissed: (() -> Void)?) {
        let registerController = UserChatListController.instantiate(delegate: self)
        router.present(registerController)
    }
}

// MARK: - UserChatListControllerDelegate
extension ChatCoordinator: UserChatListControllerDelegate {
    func userChatListControllerDidSelectChatItem(_ viewController: UserChatListController, at indexPath: IndexPath) {
        print("Selected item at row: \(indexPath.row)")
        presentChatLogController()
    }
    
    private func presentChatLogController() {
        let chatLogController = ChatLogController.instantiate(delegate: self)
        router.present(chatLogController)
    }
}

// MARK: - ChatLogControllerDelegate
extension ChatCoordinator: ChatLogControllerDelegate {
    func chatLogControllerDidPressSendMessage(_ viewController: ChatLogController) {
        print("press...")
    }
}
