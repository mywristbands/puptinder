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
        
    // Other data to keep track of in the view
    var conversationPartnerProfile: Profile? = nil
    var myProfile: Profile? = nil
    var messages: [MessageKitMessage] = []
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        Api.messages.delegate = self
                
        self.setUpHeader()
        self.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let conversationPartnerProfile = conversationPartnerProfile else {
            print("Message View was not passed a Conversation Partner Profile")
            return
        }
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        Api.profiles.getProfile { profile, error in
            if let error = error {
                print(error)
            } else {
                self.myProfile = profile
            }
            dispatchGroup.leave()
        }
        
        // Once we've gotten both our profile, we can start getting messages!
        dispatchGroup.notify(queue: DispatchQueue.main, execute: {
            Api.messages.startGettingMessages(with: conversationPartnerProfile.uid) { error in
                if let error = error {
                    print(error)
                    return
                }
            }
        })
    }
    
    func setUpHeader() {
        self.messagesCollectionView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
        
        
        let viewWidth = self.view.frame.size.width
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: 85))
        let backButton = UIButton(type: UIButton.ButtonType.system) as UIButton
        let xPostion:CGFloat = 5
        let yPostion:CGFloat = 35
        let buttonWidth:CGFloat = 90
        let buttonHeight:CGFloat = 50
        let purple = UIColor(red: 130.0/255.0, green: 94.0/255.0, blue: 246.0/255.0, alpha: 1)
        
        backButton.frame = CGRect(x:xPostion, y:yPostion, width:buttonWidth, height:buttonHeight)
        
        backButton.backgroundColor = purple
        backButton.setTitle("Back", for: UIControl.State.normal)
        backButton.titleLabel?.font = backButton.titleLabel?.font.withSize(18)
        backButton.setTitleColor(UIColor.white, for: .normal)
        backButton.addTarget(self, action: #selector(MessageView.buttonAction(_:)), for: .touchUpInside)
        
        let descLabel = UILabel(frame: CGRect(x: 5, y: 20, width: headerView.frame.size.width , height: headerView.frame.size.height - 10))
        descLabel.text = conversationPartnerProfile?.name
        descLabel.textColor = .white
        descLabel.font = descLabel.font.withSize(25)
        descLabel.textAlignment = .center
        
        headerView.backgroundColor = purple
        headerView.addSubview(descLabel)
        headerView.addSubview(backButton)
        self.view.addSubview(headerView)
    }
    
    @objc func buttonAction(_ sender:UIButton!) {
        Api.messages.stopGettingMessages { error in
            if let error = error {
                print(error)
                return
            }
        }
        self.dismiss(animated: false, completion: nil)
    }
    
    func isFromMe(message: MessageType) -> Bool {
        guard let myProfile = myProfile else {print("profileUnwrapError"); return false}
        return myProfile.uid == message.sender.senderId
    }
    
    func onReceivedNewMessage(_ message: Message) {
        // Get profile info from the view
        guard let myProfile = myProfile else {print("profileUnwrapError"); return}
        guard let conversationPartnerProfile = conversationPartnerProfile else {print("otherProfileUnwrapError"); return}
        
        // Form Sender object
        let senderName = myProfile.uid == message.sender ? myProfile.name : conversationPartnerProfile.name
        let sender = Sender(senderId: message.sender, displayName: senderName)
        
        // Insert message in message collection view and display it
        let messageKitMessage = MessageKitMessage(sender: sender, messageId: message.id, sentDate: message.timestamp.dateValue(), kind: .text(message.text))
        messages.append(messageKitMessage)
                  
        messagesCollectionView.reloadData()
        
        DispatchQueue.main.async {
            self.messagesCollectionView.scrollToBottom(animated: true)
        }
    }
    
    // MARK: Implementation for MessagesDataSourceProtocol
    func currentSender() -> SenderType {
        guard let myProfile = myProfile else {return Sender(senderId: Api.getUID(), displayName: "defaultName")}
        return Sender(senderId: Api.getUID(), displayName: myProfile.name)
    }
    
    // Finds the message associated with a given indexPath in MessageView
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    // MARK: Implementation for MessagesDisplayDelegate
    // Background color for messages
    func backgroundColor(for message: MessageType, at indexPath: IndexPath,
      in messagesCollectionView: MessagesCollectionView) -> UIColor {
      return isFromMe(message: message) ? .outgoingGreen : .incomingGray
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath,
      in messagesCollectionView: MessagesCollectionView) -> MessageStyle {

      let corner: MessageStyle.TailCorner = isFromMe(message: message) ? .bottomRight : .bottomLeft
      return .bubbleTail(corner, .curved)
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        guard let myProfile = myProfile, let conversationPartnerProfile = conversationPartnerProfile else {return}
        let avatarImage = isFromMe(message: message) ? myProfile.picture : conversationPartnerProfile.picture
        avatarView.set(avatar: Avatar(image: avatarImage))
    }

    
    // MARK: Implementation for MessageInputBarDelegate
    func inputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        guard let conversationPartnerProfile = conversationPartnerProfile else { print("error"); return }
        Api.messages.sendMessage(text: text, to: conversationPartnerProfile.uid) { error in
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
