//
//  ApiMatches.swift
//  PupTinder
//
//  Created by Elias Heffan on 11/24/19.
//  Copyright © 2019 ecs189e. All rights reserved.
//

import Foundation
import Firebase

class Matches: ApiShared {
    /**
        Gets the profile of a potential match.
        - Parameter completion: If successful, completion's `error` argument will be `nil`, else it will contain a `Optional(String)` describing the error.
    */
    func getPotentialMatch(completion: @escaping ((_ profile: Profile?, _ error: String?) -> Void)) {
        // For simplicity, we assume best match is a random match
        let profiles = db.collection("profiles")
        let randKey = profiles.document().documentID
        var query = profiles.whereField("__name__", isGreaterThanOrEqualTo: randKey).order(by: "__name__").limit(to: 1)
        query.getDocuments { (querySnapshot, err) in
            if let _ = err {
                // Document was not found, so wrap-around and query on low value which is the empty string
                query = profiles.whereField("__name__", isGreaterThanOrEqualTo: "").order(by: "__name__").limit(to: 1)
                query.getDocuments { (querySnapshot, err) in
                    if let err = err {
                        // Error should technically be impossible, unless there are no profiles in the datebase
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                        }
                    }
                }
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }

    /**
        Adds specified user to our list of users that the current user has "swiped right" on.
        - Parameter uid: the uid of the user who we are accepting as a match.
        - Parameter completion: If successful, completion's `error` argument will be `nil`, else it will contain a `Optional(String)` describing the error.
         */
    func swipedRightOn(uid: String, completion: @escaping ((_ error: String?) -> Void)) {
        // TODO: Implement this function!
        
        // TODO: See "IMPORTANT NOTE" below
    }

    /** Gets all the profiles of users who the current user has been matched with.
        - Parameter completion: If successful, completion's `error` argument will be `nil`, else it will contain a `Optional(String)` describing the error.
    */
    func getMatches(completion: ((_ profiles: [Profile]?, _ error: String?) -> Void)) {
        // TODO: Implement this function!
    }
}
/*
 ***************IMPORTANT NOTE*****************************
    We’ll need to also create a firebase Admin SDK “function” (whoever implements this will need to look up the details on how to do this) which will be triggered whenever someone swipes right. This function will check if the person who they swiped right on also swiped right on them, in which case it would add a new document to the matches collection with the `members` list containing both of their UIDs, and the `timestamp` containing the time that the match was found (whatever the current time is).
    The reason we have to do this is outside the client code is we don’t want to let just anyone add entries to the `matches` collection, or else a malicious person could wreak havoc by matching random people together.
    */
