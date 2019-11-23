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
    var picture: UIImage
    var name: String
    var breed: String
    var size: String
    var bio: String
    var traits: [String]
    var characteristics: [String]
}
// For initializing a Profile with data from firestore
extension Profile {
    init(data: [String:Any?]) {
        picture = data["picture"] as? UIImage ?? UIImage()
        name = data["name"] as? String ?? ""
        breed = data["breed"] as? String ?? ""
        size = data["size"] as? String ?? ""
        bio = data["bio"] as? String ?? ""
        traits = data["traits"] as? [String] ?? []
        characteristics = data["characteristics"] as? [String] ?? []
    }
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
    static let db = Firestore.firestore()
    static let storage = Storage.storage().reference()
    static var delegate: NewMessageChecker?
    
    static private func getUID() -> String {
        guard let uid =  Auth.auth().currentUser?.uid else {return ""}
        return uid
    }
        
    static private func getAuthErrorCode(_ error: Error?) -> AuthErrorCode? {
        let nsError = error as NSError?
        guard let errorCode = nsError?.code else {return nil}
        return AuthErrorCode(rawValue: errorCode)
    }

    static private func getStorageErrorCode(_ error: Error?) -> StorageErrorCode? {
        let nsError = error as NSError?
        guard let errorCode = nsError?.code else {return nil}
        return StorageErrorCode(rawValue: errorCode)
    }
        
    /// Signs new user up.
    /// - Parameter completion: If successful, completion's `error` argument will be `nil`, else it will contain a `Optional(String)` describing the error for now it just always says "Failed to sign up").
    static func signup(email: String, password: String, completion: @escaping ((_ error: String?) -> Void)) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            guard let errorCode = getAuthErrorCode(error) else {
                completion(nil) // No error occurred
                return
            }
            
            switch (errorCode) {
            case .invalidEmail:
                completion("Don't think that's an email address!")
            case .emailAlreadyInUse:
                completion("Email already in use by another account.")
            case .weakPassword:
                guard let specificReason = (error as NSError?)?.userInfo[NSLocalizedFailureReasonErrorKey] as? String else {
                    completion("Password is too weak.")
                    return
                }
                completion(specificReason)
            default:
                completion("Sign up failed for unknown reason")
            }
        }
    }
    
    /// Logs user in.
    /// - Parameter completion: If successful, completion's `error` argument will be `nil`, else it will contain a `Optional(String)` describing the error (for now it just always says "Failed to sign in").
    static func login(email: String, password: String, completion: @escaping ((_ error: String?) -> Void)) {
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            
            guard let errorCode = getAuthErrorCode(error) else {
                completion(nil) // No error occurred
                return
            }
                        
            switch (errorCode) {
            case .invalidEmail:
                completion("Don't think that's an email address!")
            case .userDisabled:
                completion("Your account has been disabled.")
            case .wrongPassword:
                completion("Incorrect password, please try again.")
            default:
                completion("Login failed for an unknown reason.")
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
    
    /// Uploads profile for a new user.
    /// - Parameter completion: If successful, completion's `error` argument will be `nil`, else it will contain a `Optional(String)` describing the error.
    static func uploadProfile(profile: Profile, completion: @escaping ((_ error: String?) -> Void)) {
        
        guard let filepath = uploadProfilePicture(profile.picture) else {
            print("Could not prepare profile picture for upload")
            return
        }
       
       // Upload profile
        db.collection("profiles").document(getUID()).setData(["picture":filepath,"name":profile.name,"breed":profile.breed,"size":profile.size,"bio":profile.bio,"traits":profile.traits,"characteristics":profile.traits])
    }
        
    static private func uploadProfilePicture(_ picture: UIImage) -> String? {
        
        // We will name profile pictures based on the uid of the corresponding user
        let filepath = "profilePictures/" + getUID()
         
        // Create a reference to the location to upload picture to
        let profilePicRef = storage.child(filepath)
        
        // Convert profile picture to raw data, compresssed
        guard let rawPicData = picture.jpegData(compressionQuality: 0.7) else {return nil}

        // Upload profile picture data
        profilePicRef.putData(rawPicData, metadata: nil) { (metadata, error) in
            if error != nil {
                print("Could not upload profile picture")
            }
        }
        return filepath
    }
    
    /**
        Gets the profile of the current user.
        - Parameter completion: If successful, completion's `error` argument will be `nil`, else it will contain a `Optional(String)` describing the error.

        Possible error strings so far include:
        "You don't have a profile picture!"
        "Your profile picture is too big to download."
        "Couldn't get profile picture for an unknown reason."
        "Profile was never created."
     */
    static func getProfile(completion: @escaping ((_ profile: Profile?, _ error: String?) -> Void)) {
        getProfilePicture { (image, error) in
            // Now that we have attempted to get our profile picture...
            
            // Complete with error if error occurred in getting profile picture
            if let error = error {
                completion(nil, error)
            }
            
            // Otherwise, get the rest of the Profile info
            let profileLocation = db.collection("profiles").document(getUID())

            profileLocation.getDocument { (document, error) in
                if let document = document, document.exists {
                    guard var profileData = document.data() else {return}
                    guard let image = image else {return}
                    profileData["picture"] = image // Add profile picture to profile data
                    let profile = Profile(data: profileData)
                    completion(profile, nil) // Finally pass back the profile info!
                } else {
                    completion(nil, "Profile was never created")
                }
            }
        }
    }
    
    static private func getProfilePicture(completion: @escaping ((_ image: UIImage?, _ error: String?) -> Void)) -> Void {
        
        let profilePicLocation = storage.child("profilePictures/" + getUID())

        // Download pic to memory with a maximum allowed size of 1MB
        profilePicLocation.getData(maxSize: 1 * 1024 * 1024) { data, error in
            guard let errorCode = getStorageErrorCode(error) else {
                // No error occurred!
                guard let data = data else {return}
                completion(UIImage(data: data), nil)
                return
            }
            
            switch (errorCode) {
            case .objectNotFound:
                completion(nil, "You don't have a profile picture!")
            case .downloadSizeExceeded:
                completion(nil, "Your profile picture is too big to download.")
            default:
                completion(nil, "Couldn't get profile picture for an unknown reason.")
            }
        }
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
    
    /** Stops listening for new messages from a specific other user.
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
