//
//  MessageView.swift
//  PupTinder
//
//  Created by Hajra Mobashar on 12/1/19.
//  Copyright © 2019 ecs189e. All rights reserved.
//

import UIKit
import MessageKit

struct MessageKitMessage: MessageType {
    let sender: SenderType
    let messageId: String
    let sentDate: Date
    let kind: MessageKind
}

class MessageView: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, MessageInputBarDelegate, NewMessageChecker {
    
    // Pass this into MessageView was seguing in so that it knows who you're in conversation with
    let conversationPartnerUid: String? = "ROKKZ2Dlr2c2rF8on5HlJszNd112"
    
    // Other data to keep track of in the view
    var conversationPartnerProfile: Profile? = nil
    var myProfile: Profile? = nil
    var currSender: Sender? = nil
    var messages: [MessageKitMessage] = []
     
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        Api.messages.delegate = self
        
        guard let conversationPartnerUid = conversationPartnerUid else {
            print("Message View was not passed a Conversation Partner")
            return
        }
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        Api.profiles.getProfileOf(uid: conversationPartnerUid) { profile, error in
            if let error = error {
                print(error)
            } else {
                self.conversationPartnerProfile = profile
            }
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        Api.profiles.getProfile { profile, error in
            if let error = error {
                print(error)
            } else {
                self.myProfile = profile
            }
            dispatchGroup.leave()
        }
        
        // Once we've gotten both our profile and the other user's profile, we can start getting messages!
        dispatchGroup.notify(queue: DispatchQueue.main, execute: {
            Api.messages.startGettingMessages(with: conversationPartnerUid) { error in
                if let error = error {
                    print(error)
                    return
                }
            }
        })
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func isFromMe(message: MessageType) -> Bool {
        guard let myProfile = myProfile else {print("profileUnwrapError"); return false}
        return myProfile.uid == message.messageId
    }
    
    func onReceivedNewMessage(_ message: Message) {
        // Get profile info from the view
        guard let myProfile = myProfile else {print("profileUnwrapError"); return}
        guard let conversationPartnerProfile = conversationPartnerProfile else {print("otherProfileUnwrapError"); return}
        
        // Form Sender object
        let senderName = myProfile.uid == message.sender ? myProfile.name : conversationPartnerProfile.name
        currSender = Sender(senderId: message.sender, displayName: senderName)
        guard let currSender = currSender else {print("currSenderUnwrapError"); return}
        
        // Insert message in message collection view and display it
        let messageKitMessage = MessageKitMessage(sender: currSender, messageId: message.id, sentDate: message.timestamp.dateValue(), kind: .text(message.text))
        messages.append(messageKitMessage)
                  
        messagesCollectionView.reloadData()
        
        DispatchQueue.main.async {
            self.messagesCollectionView.scrollToBottom(animated: true)
        }
    }
    
    // MARK: Implementation for MessagesDataSourceProtocol
    func currentSender() -> SenderType {
        return currSender ?? Sender(senderId: "", displayName: "default")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    // MARK: Implementation for MessagesLayoutDelegate
    // We don't want to show the person's profile picture for now, so we'll make it zero big.
    func avatarSize(for message: MessageType, at indexPath: IndexPath,
      in messagesCollectionView: MessagesCollectionView) -> CGSize {
      return .zero
    }
    
    // MARK: Implementation for MessagesDisplayDelegate
    // Background color for messages
    func backgroundColor(for message: MessageType, at indexPath: IndexPath,
      in messagesCollectionView: MessagesCollectionView) -> UIColor {
      return isFromMe(message: message) ? .outgoingGreen : .incomingGray
    }

    func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath,
      in messagesCollectionView: MessagesCollectionView) -> Bool {
      return true
    }

    func messageStyle(for message: MessageType, at indexPath: IndexPath,
      in messagesCollectionView: MessagesCollectionView) -> MessageStyle {

      let corner: MessageStyle.TailCorner = isFromMe(message: message) ? .bottomRight : .bottomLeft
      return .bubbleTail(corner, .curved)
    }
    
    // MARK: Implementation for MessageInputBarDelegate
    func inputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        guard let conversationPartnerUid = conversationPartnerUid else { print("error"); return }
        Api.messages.sendMessage(text: text, to: conversationPartnerUid) { error in
            if let error = error {
                print(error)
            }
        }
        inputBar.inputTextView.text = ""
    }

}

private extension UIColor {
    static let incomingGray = UIColor(red: 230/255, green: 230/255, blue: 235/255, alpha: 1.0)
    static let outgoingGreen = UIColor(red: 69/255, green: 214/255, blue: 93/255, alpha: 1.0)
}
