//
//  ApiHelper.swift
//  PupTinder
//
//  Created by Elias Heffan on 11/24/19.
//  Copyright © 2019 ecs189e. All rights reserved.
//

import Foundation
import Firebase

class ApiShared {
    let db = Firestore.firestore()

    func getUID() -> String {
        guard let uid =  Auth.auth().currentUser?.uid else {
            print("Couldn't get user's uid")
            return ""
        }
        return uid
    }
    static func getUID() -> String {
        guard let uid =  Auth.auth().currentUser?.uid else {
            print("Couldn't get user's uid")
            return ""
        }
        return uid
    }
}
