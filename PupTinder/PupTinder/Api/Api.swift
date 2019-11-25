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

// As we're implementing this Api, reference our database structure here:
// https://drive.google.com/file/d/1wh2Bb0nTlIzK-a9Kbr89DsQotLfsNNRN/view?usp=sharing
class Api: ApiShared {
    
    // Contains: signup, login, logout
    static let auth = Authing()
    
    // Contains: uploadProfile, getProfile, getProfileOf, updateProfile
    static let profiles = Profiles()
    
    // Conains: getPotentialMatch, swipedRightOn, getMatches
    static let matches = Matches()
    
    // Contains: getConversations, getMessages, sendMessage, startListeningForNewMessages, stopListeningForNewMessages
    // Also Contains: NewMessageChecker protocol
    static let messages = Messages()

}
