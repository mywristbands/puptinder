//
//  Api.swift
//  PupTinder
//
//  Created by Elias Heffan on 11/17/19.
//  Copyright © 2019 ecs189e. All rights reserved.
//

import Foundation
import UIKit
import Firebase

struct Profile {
    var uid: String    // **** TODO: discuss that it's profile_uid in db
    var picture: UIImage
    var name: String
    var breed: String
    var size: String
    var bio: String
    var traits: [String]
    var characteristics: [String]
}

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

// As we're implementing this Api, reference our database structure here:
// https://drive.google.com/file/d/1wh2Bb0nTlIzK-a9Kbr89DsQotLfsNNRN/view?usp=sharing
class Api {
    static var ref: DatabaseReference!
    static let db = Firestore.firestore()
    static var delegate: NewMessageChecker?
    
    /// Signs new user up.
    /// - Parameter completion: If successful, completion's `error` argument will be `nil`, else it will contain a `Optional(String)` describing the error for now it just always says "Failed to sign up").
    static func signup(email: String, password: String, completion: @escaping ((_ error: String?) -> Void)) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error != nil {
                completion("Failed to sign up!")
            } else {
                completion(nil)
            }
        }
    }
    
    /// Logs user in.
    /// - Parameter completion: If successful, completion's `error` argument will be `nil`, else it will contain a `Optional(String)` describing the error (for now it just always says "Failed to sign in").
    static func login(email: String, password: String, completion: @escaping ((_ error: String?) -> Void)) {
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if error != nil {
                completion("Failed to sign in")
            } else {
                completion(nil)
                // Note that this code below is just testing code; we wouldn't actually insert the user's username into our database after they log in
                self.ref = Database.database().reference()
                if let userID = Auth.auth().currentUser?.uid {
                    self.ref.child("users").child(userID).setValue(["username": "username1"])
                }
            }
        }
    }
    
    /// Logs user out.
    /// - Returns: `nil` if logout was success, else an `Optional(String)` containing an error message.
    static func logout() -> String? {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            return String(format: "Error signing out: %@", signOutError)
        }
        return nil
    }
    
    /// Creates profile for a new user.
    /// - Parameter completion: If successful, completion's `error` argument will be `nil`, else it will contain a `Optional(String)` describing the error.
    static func createProfile(profile: Profile, completion: @escaping ((_ error: String?) -> Void)) {
        //db.collection("profiles").addDocument(data:)
        // TODO: Implement this function!
    }
    
    /**
        Gets the profile of the current user.
        - Parameter completion: If successful, completion's `error` argument will be `nil`, else it will contain a `Optional(String)` describing the error.

        Possible error strings so far include:
        "user has not created a profile", if an account has been created but no profile has yet been created.
     */
    static func getProfile(completion: @escaping ((_ profile: Profile?, _ error: String?) -> Void)) {
        // TODO: Implement this function!
    }
    
    /**
        Updates the profile of the current user.
        - Parameter completion: If successful, completion's `error` argument will be `nil`, else it will contain a `Optional(String)` describing the error.
     */
    static func updateProfile(profile: Profile, completion: ((_ error: String?) -> Void)) {
        // TODO: Implement this function!
    }
    
    /**
        Gets the profile of a specific other user.
        - Parameter uid: the uid of the user whose profile we want to get.
        - Parameter completion: If successful, completion's `error` argument will be `nil`, else it will contain a `Optional(String)` describing the error.
     
        You might want to use this function to get another user's name, like when messaging someone.
    */
    static func getProfileOf(uid: String, completion: @escaping ((_ profile: Profile?, _ error: String?) -> Void)) {
        // TODO: Implement this function!
    }
    
    /**
        Gets the profile of a potential match.
        - Parameter completion: If successful, completion's `error` argument will be `nil`, else it will contain a `Optional(String)` describing the error.
    */
    static func getPotentialMatch(completion: @escaping ((_ profile: Profile?, _ error: String?) -> Void)) {
        // TODO: Implement this function!
    }

    /**
        Adds specified user to our list of users that we have "swiped right" on.
        - Parameter uid: the uid of the user who we are accepting as a match.
        - Parameter completion: If successful, completion's `error` argument will be `nil`, else it will contain a `Optional(String)` describing the error.
         */
    static func swipedRightOn(uid: String, completion: @escaping ((_ error: String?) -> Void)) {
        // TODO: Implement this function!
    }

    /** Gets all the profiles of users who we have matched.
        - Parameter completion: If successful, completion's `error` argument will be `nil`, else it will contain a `Optional(String)` describing the error.
    */
    static func getMatches(completion: ((_ profiles: [Profile]?, _ error: String?) -> Void)) {
        // TODO: Implement this function!
    }

    /** Gets all the conversations started with the users who we have been matched with. (NOTE: messages property will start out as empty for each conversation returned, so you'll need to call `getMessages` to fill that info in when you need it)
        - Parameter completion: If successful, completion's `error` argument will be `nil`, else it will contain a `Optional(String)` describing the error.
    */
    static func getConversations(completion: ((_ conversations: [Conversation]?, _ error: String?) -> Void)) {
        // TODO: Implement this function!
    }
    
    /** Gets all the messages in a particular conversation.
        - Parameter from: the uid of the user we're in the conversation with
        - Parameter completion: If successful, completion's `error` argument will be `nil`, else it will contain a `Optional(String)` describing the error.
     
        Some possible errors include:
        "conversation has no messages"
     */
    static func getMessages(from: String, completion: ((_ messages: [Message]?, _ error: String?) -> Void)) {
        // TODO: Implement this function!
    }
    
    /** Sends a message to another user.
        - Parameter from: the uid of the user we want to send the message to.
        - Parameter completion: If successful, completion's `error` argument will be `nil`, else it will contain a `Optional(String)` describing the error.
     */
    static func sendMessage(message: Message, to: String, completion: ((_ error: String?) -> Void)) {
        // TODO: Implement this function!
    }
    
    /** Begins listening for new messages from a specific other user.
        - Parameter from: the uid of the user we want to listen for new messages from.
        - Parameter completion: If successful, completion's `error` argument will be `nil`, else it will contain a `Optional(String)` describing the error.
     */
    static func startListeningForNewMessages(from: String, completion: ((_ error: String?) -> Void)) {
        // TODO: Implement this function!
        
        // Useful link for implementing this function: firebase.google.com/docs/firestore/query-data/listen
        
        // Will need to call `delegate?.onReceivedNewMessage()` here.
    }
    
    /** Stops listening for new messages from a specific user.
        - Parameter from: the uid of the user we want to stop listening for new messages from.
        - Parameter completion: If successful, completion's `error` argument will be `nil`, else it will contain a `Optional(String)` describing the error.
     */
    static func stopListeningForNewMessages(from: String, completion: ((_ error: String?) -> Void)) {
        // TODO: Implement this function!
        
        // Useful link for implementing this function: firebase.google.com/docs/firestore/query-data/listen
    }
    

    /*
     ***************IMPORTANT NOTE*****************************
        We’ll need to also create a firebase Admin SDK “function” (whoever implements this will need to look up the details on how to do this) which will be triggered whenever someone swipes right. This function will check if the person who they swiped right on also swiped right on them, in which case it would add a new document to the matches collection with the `members` list containing both of their UIDs, and the `timestamp` containing the time that the match was found (whatever the current time is).
        The reason we have to do this is outside the client code is we don’t want to let just anyone add entries to the `matches` collection, or else a malicious person could wreak havoc by matching random people together.
        */
}
