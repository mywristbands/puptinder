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
// For initializing a Message with data from firestore
extension Message {
    init(data: [String:Any?]) {
        sender = data["sender"] as? String ?? ""
        text = data["text"] as? String ?? ""
        timestamp = data["timestamp"] as? Timestamp ?? Timestamp()
    }
}

/// To define how you'd like to update the View when you receive new messages, implement this protocol, and then set `Api.messages.delegate = self`.
/// Also make sure to call `Api.messages.startListeningForNewMessages()` to start listening for new messages.
protocol NewMessageChecker {
    func onReceivedNewMessage(_ message: Message)
}

class Messages: ApiShared {
    var delegate: NewMessageChecker?
    var messageListener: ListenerRegistration?
    var listeningForMessagesWith: String?
    
    /** Gets the profiles of all of the users that the current user has started a conversation with, from most-recently-spoken-with to least-recently-spoken-with.
        - Parameter completion: If successful, completion's `error` argument will be `nil`, else it will contain a `Optional(String)` describing the error.
    */
    func getConversationPartners(completion: ((_ conversationPartners: [Profile]?, _ error: String?) -> Void)) {
        // TODO: Implement this function!
        // Note: A user has "started a conversation with someone" if they have matched with that person and there is at least one message in their messages collection.
    }
    
    /** Sends a message to another user.
        - Parameter from: the uid of the user we want to send the message to.
        - Parameter completion: If successful, completion's `error` argument will be `nil`, else it will contain a `Optional(String)` describing the error.
     */
    func sendMessage(message: Message, to: String, completion: ((_ error: String?) -> Void)) {
        // TODO: Implement this function!
        
        // It will probably be useful to call getMatchDoc() here that Elias made.
    }
    
    /** Get all messages in the conversation between the current user and a specific other user, and then continue listening for new messages in the conversation (from both the current user and the other user).
        - Parameter with: the uid of the user whose conversation we want to get messages from.
        - Parameter completion: If successful, completion's `error` argument will be `nil`, else it will contain a `Optional(String)` describing the error.
     */
    func startGettingMessages(with otherUID: String, completion: @escaping ((_ error: String?) -> Void)) {
        if let uid = listeningForMessagesWith {
            completion("Already listening for new messages from \(uid). If you'd like to listen for messages from a new user, first stop listening for messages from the currently set user by calling `stopListeningForNewMessages()`.")
            return
        }
        
        // Get the match document between the current user and otherUID
        getMatchDoc(between: getUID(), and: otherUID) { matchDoc, error in
            guard let matchDoc = matchDoc else {
                completion(error!) // Will always unwrap due to our setup.
                return
            }
                        
            // We've successfully got the match document, so now add a listener for messages from the other person in the match
            self.messageListener = matchDoc.reference.collection("messages").order(by: "timestamp").addSnapshotListener { querySnapshot, error in
                                
                guard let querySnapshot = querySnapshot else {
                    print("Error querying messages with \(otherUID): \(error!)") // Will always unwrap due to snapshotListener setup.
                    return
                }

                // Upon new message added by other user, notify app about the change.
                querySnapshot.documentChanges.forEach { diff in
                    if (diff.type == .added) {
                        let newMessage = diff.document.data()
                        self.delegate?.onReceivedNewMessage(Message(data: newMessage))
                    }
                }
            }
            
            // Set which user you're listening for messages with (both your own messages and the other user's messages)
            self.listeningForMessagesWith = otherUID

            completion(nil) // Listener setup success!
        }
    }
    
    /** Stops listening for messages in the conversation with whatever user you last started listening for messages.
        - Parameter completion: If successful, completion's `error` argument will be `nil`, else it will contain a `Optional(String)` describing the error.
     */
    func stopGettingMessages(completion: ((_ error: String?) -> Void)) {
        if let messageListener = self.messageListener {
            messageListener.remove()
            self.messageListener = nil
            self.listeningForMessagesWith = nil
            completion(nil)
        } else {
            completion("Never started listening for messages.")
        }
    }
    
    private func getMatchDoc(between uid1: String, and uid2: String, completion: @escaping ((_ matchDoc: DocumentSnapshot?, _ error: String?) -> Void)) {
        // Get all matches for uid1
        db.collection("matches").whereField("members", arrayContains: uid1)
        .getDocuments { querySnapshot, error in
            if let error = error {
                completion(nil, "Error getting matches for \(uid1): \(error)")
            } else {
                guard let querySnapshot = querySnapshot else {
                    completion(nil, "querySnapshot for \(uid1)'s matches could not be unwrapped")
                    return
                }
                // Find a match containing uid2 as well.
                for matchDoc in querySnapshot.documents {
                    guard let members = matchDoc.data()["members"] as? [String] else {continue}
                    if members.contains(uid2) {
                        // We found the matchDoc containing both uid1 and uid2
                        completion(matchDoc, nil)
                        return
                    }
                }
                // If we got here, we were unable to find a matchDoc between uid1 and uid2
                completion(nil, "Could not find a match document for \(uid1) and \(uid2).")
            }
        }
    }
}
