//
//  ApiMessages.swift
//  PupTinder
//
//  Created by Elias Heffan on 11/24/19.
//  Copyright © 2019 ecs189e. All rights reserved.
//

import Foundation
import Firebase


struct Conversation {
    var partner: String // the other user's uid
    var messages: [Message]
}

struct Message {   // TODO: might need to modify this to conform to MessageKit
    var sender: String // the sender's uid
    var text: String
    var timestamp: Timestamp
}

/// To define how you'd like to update the View when you receive new messages, implement this protocol. (also make sure to call Api.startListeningForNewMessages() to start listening for new messages).
protocol NewMessageChecker {
    func onReceivedNewMessage(_ message: Message)
}

class Messages: ApiShared {
    var delegate: NewMessageChecker?
    
    /** Gets all the conversations started with the users who the current user has been matched with. (NOTE: messages property will start out as empty for each conversation returned, so you'll need to call `getMessages` to fill that info in when you need it)
        - Parameter completion: If successful, completion's `error` argument will be `nil`, else it will contain a `Optional(String)` describing the error.
    */
    func getConversations(completion: ((_ conversations: [Conversation]?, _ error: String?) -> Void)) {
        // TODO: Implement this function!
    }
    
    /** Gets all the messages in a particular conversation.
        - Parameter from: the uid of the user we're in the conversation with
        - Parameter completion: If successful, completion's `error` argument will be `nil`, else it will contain a `Optional(String)` describing the error.
     
        Some possible errors include:
        "conversation has no messages"
     */
    func getMessages(from: String, completion: ((_ messages: [Message]?, _ error: String?) -> Void)) {
        // TODO: Implement this function!
    }
    
    /** Sends a message to another user.
        - Parameter from: the uid of the user we want to send the message to.
        - Parameter completion: If successful, completion's `error` argument will be `nil`, else it will contain a `Optional(String)` describing the error.
     */
    func sendMessage(message: Message, to: String, completion: ((_ error: String?) -> Void)) {
        // TODO: Implement this function!
    }
    
    /** Begins listening for new messages from a specific other user.
        - Parameter from: the uid of the user we want to listen for new messages from.
        - Parameter completion: If successful, completion's `error` argument will be `nil`, else it will contain a `Optional(String)` describing the error.
     */
    func startListeningForNewMessages(from: String, completion: ((_ error: String?) -> Void)) {
        // TODO: Implement this function!
        
        // Useful link for implementing this function: firebase.google.com/docs/firestore/query-data/listen
        
        // Will need to call `delegate?.onReceivedNewMessage()` here.
    }
    
    /** Stops listening for new messages from a specific other user.
        - Parameter from: the uid of the user we want to stop listening for new messages from.
        - Parameter completion: If successful, completion's `error` argument will be `nil`, else it will contain a `Optional(String)` describing the error.
     */
    func stopListeningForNewMessages(from: String, completion: ((_ error: String?) -> Void)) {
        // TODO: Implement this function!
        
        // Useful link for implementing this function: firebase.google.com/docs/firestore/query-data/listen
    }

}
