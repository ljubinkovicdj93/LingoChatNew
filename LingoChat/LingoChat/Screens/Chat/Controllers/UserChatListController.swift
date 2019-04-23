// Project: LingoChat
//
// Created on Sunday, March 24, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import UIKit

private let reuseIdentifier = "Cell"

protocol UserChatListControllerDelegate: class {
    func userChatListControllerDidSelectChatItem(_ viewController: UserChatListController, at indexPath: IndexPath)
}

class UserChatListController: UICollectionViewController {

    weak var delegate: UserChatListControllerDelegate?
    
    var token: Token?
    var userChats: [Chat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUserChats()
        
        print("INSIDE USER CHAT LIST")

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    private func fetchUserChats() {
        guard let userID = token?.userID else { return }

        let userUUID = UUID(uuidString: userID)
        UserService.getChats(for: userUUID) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let chats):
                self.userChats = chats
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print("UCLC ERROR:", error.localizedDescription)
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return userChats.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
        cell.backgroundColor = .red
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.userChatListControllerDidSelectChatItem(self, at: indexPath)
    }
}

extension UserChatListController {
    class func instantiate(delegate: UserChatListControllerDelegate) -> UserChatListController {
        let userChatListController = UserChatListController.controller(from: .chat)
        userChatListController.delegate = delegate
        return userChatListController
    }
}
