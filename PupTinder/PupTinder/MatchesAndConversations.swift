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
        return Sender(id: "any_unique_id", displayName: "Bob")
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func cellTopLabelAttributedText(for message: MessageType,
      at indexPath: IndexPath) -> NSAttributedString? {

      let name = "Bob"
      return NSAttributedString(
        string: name,
        attributes: [
          .font: UIFont.preferredFont(forTextStyle: .caption1),
          .foregroundColor: UIColor(white: 0.3, alpha: 1)
        ]
      )
    }
}

extension MatchesAndConversations: MessagesLayoutDelegate {

  func avatarSize(for message: MessageType, at indexPath: IndexPath,
    in messagesCollectionView: MessagesCollectionView) -> CGSize {
    return .zero
  }

  func footerViewSize(for message: MessageType, at indexPath: IndexPath,
    in messagesCollectionView: MessagesCollectionView) -> CGSize {
    return CGSize(width: 0, height: 8)
  }

  func heightForLocation(message: MessageType, at indexPath: IndexPath,
    with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
    return 0
  }
}

extension MatchesAndConversations: MessagesDisplayDelegate {
    
}
