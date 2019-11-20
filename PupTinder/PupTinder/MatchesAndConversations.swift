//
//  MatchesAndConversations.swift
//  PupTinder
//
//  Created by Elias Heffan on 11/17/19.
//  Copyright © 2019 ecs189e. All rights reserved.
//

import UIKit
import MessageKit

class MatchesAndConversations: MessagesViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    
    
    

}

let sender = Sender(id: "any_unique_id", displayName: "Steven")
let messages: [MessageType] = []

extension MatchesAndConversations: MessagesDataSource {
    func currentSender() -> SenderType {
        return Sender(id: "any_unique_id", displayName: "Steven")
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
}
extension MatchesAndConversations: MessagesDisplayDelegate, MessagesLayoutDelegate {}
