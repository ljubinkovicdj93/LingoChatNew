// Project: LingoChat
//
// Created on Sunday, March 24, 2019.
// Copyright © 2019 Dorde Ljubinkovic. All rights reserved.

import UIKit

private let reuseIdentifier = "Cell"

protocol ChatLogControllerDelegate: class {
    func chatLogControllerDidPressSendMessage(_ viewController: ChatLogController)
}

class ChatLogController: UICollectionViewController {

    weak var delegate: ChatLogControllerDelegate?
    
    var chatDetails: Chat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = chatDetails.title
        
        print("INSIDE USER CHAT LOG")

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
        return 15
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
        cell.backgroundColor = .blue
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.chatLogControllerDidPressSendMessage(self)
    }
}

extension ChatLogController {
    class func instantiate(delegate: ChatLogControllerDelegate) -> ChatLogController {
        let chatLogController = ChatLogController.controller(from: .chat)
        chatLogController.delegate = delegate
        return chatLogController
    }
}
