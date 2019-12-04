//
//  MessageView.swift
//  PupTinder
//
//  Created by Hajra Mobashar on 12/1/19.
//  Copyright © 2019 ecs189e. All rights reserved.
//

import UIKit
import MessageKit

class MessageView: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, NewMessageChecker {
    
    let conversationPartner: String? = nil // uid of conversation partner
    let sender = Sender(id: "any_unique_id", displayName: "Steven")
    var messages: [MessageType] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self

        
        guard let conversationPartner = conversationPartner else {
            print("Message View was not passed a Conversation Partner")
            return
        }
        Api.messages.startGettingMessages(with: conversationPartner) { error in
            if let error = error {
                print(error)
                return
            }
        }

    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func onReceivedNewMessage(_ message: Message) {
        <#code#>
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
