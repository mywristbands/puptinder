//
//  MessageView.swift
//  PupTinder
//
//  Created by Hajra Mobashar on 12/1/19.
//  Copyright © 2019 ecs189e. All rights reserved.
//

import UIKit
import MessageKit

class MessageView: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    let sender = Sender(id: "any_unique_id", displayName: "Steven")
    var messages: [MessageType] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    // Implementation for MessagesDataSourceProtocol
    func currentSender() -> SenderType {
        return Sender(id: "any_unique_id", displayName: "Steven")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }

}
