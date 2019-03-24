// Project: LingoChat
//
// Created on Sunday, March 24, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import UIKit

class ChatCoordinator: Coordinator {
    var children: [Coordinator] = []
    var router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    func present(animated: Bool, onDismissed: (() -> Void)?) {
        let registerController = UserChatListController.instantiate(delegate: self)
        router.present(registerController)
    }
}

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

extension ChatCoordinator: ChatLogControllerDelegate {
    func chatLogControllerDidPressSendMessage(_ viewController: ChatLogController) {
        print("press...")
    }
}
