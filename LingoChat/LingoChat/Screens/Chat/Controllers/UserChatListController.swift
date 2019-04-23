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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("INSIDE USER CHAT LIST")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 5
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
