// Project: LingoChat
//
// Created on Sunday, March 24, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import UIKit

private let reuseIdentifier = "Cell"

protocol UserChatListControllerDelegate: class {
    func userChatListControllerDidSelectChatItem(_ viewController: UserChatListController, chatItem: Chat)
}

class UserChatListController: UICollectionViewController {

    weak var delegate: UserChatListControllerDelegate?
    
    var token: Token?
    private var chats: [Chat] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let currentUserId = AuthManager.shared.currentUser?.id else { return }
         
        UserService.getChats(for: currentUserId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let chats):
                self.chats = chats
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        print("INSIDE USER CHAT LIST")

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chats.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        // Configure the cell
        cell.backgroundColor = .red
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard chats.count > 0 else { return }
        let chatItem = chats[indexPath.row]
        delegate?.userChatListControllerDidSelectChatItem(self, chatItem: chatItem)
    }
}

extension UserChatListController {
    class func instantiate(delegate: UserChatListControllerDelegate) -> UserChatListController {
        let userChatListController = UserChatListController.controller(from: .chat)
        userChatListController.delegate = delegate
        return userChatListController
    }
}
