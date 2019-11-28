//
//  ApiMessages.swift
//  PupTinder
//
//  Created by Elias Heffan on 11/24/19.
//  Copyright © 2019 ecs189e. All rights reserved.
//

import Foundation
import Firebase

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
    
    /** Gets the profiles of all of the users that the current user has started a conversation with, from most-recently-spoken-with to least-recently-spoken-with.
        - Parameter completion: If successful, completion's `error` argument will be `nil`, else it will contain a `Optional(String)` describing the error.
    */
    func getConversationPartners(completion: ((_ conversationPartners: [Profile]?, _ error: String?) -> Void)) {
        // TODO: Implement this function!
        // Note: A user has "started a conversation with someone" if they have matched with that person and there is at least one message in their messages collection.
    }
    
    /** Gets all the messages in a particular conversation.
        - Parameter from: the uid of the user we're in the conversation with
        - Parameter completion: If successful, completion's `error` argument will be `nil`, else it will contain a `Optional(String)` describing the error.
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
