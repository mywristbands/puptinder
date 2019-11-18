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
    var uid: String
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

struct Message {
    var sender: String // the sender's uid
    var text: String
    var timestamp: Timestamp
}

protocol NewMessageChecker {
    func onReceivedNewMessage(_ message: Message)
}

class Api {
    static var ref: DatabaseReference!
    static var delegate: NewMessageChecker?
    
    static func signup(email: String, password: String, completion: @escaping ((_ error: String?) -> Void)) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error != nil {
                completion("Failed to sign up!")
            } else {
                completion(nil)
            }
        }
    }
    
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
}
