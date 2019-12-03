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
                        completion(nil, "Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            Api.profiles.getProfileOf(uid: document.documentID, completion: completion)
                        }
                    }
                }
            } else {
                for document in querySnapshot!.documents {
                    Api.profiles.getProfileOf(uid: document.documentID, completion: completion)
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
        if uid == getUID() {
            completion("You can't swipe right on yourself!")
            return
        } else if uid == "" {
            completion("You didn't provide a uid to swipe on.")
            return
        }
        db.collection("profiles").document(self.getUID()).collection("swipedRight").document(uid).setData([:]) { error in
            if let _ = error {
                completion("Error occurred when swiping right on \(uid)")
            } else {
                completion(nil) // Successfully swiped right!
            }
        }
    }
    
    /** Gets all the profiles of users who the current user has been matched with.
        - Parameter completion: If successful, completion's `error` argument will be `nil`, else it will contain a `Optional(String)` describing the error.
    */
    func getMatches(completion: @escaping ((_ profiles: [Profile]?, _ error: String?) -> Void)) {
        let uid = getUID()
        var profileArray:[Profile]?
        // In the matches collection, query all documents with this uid in the members array
        let query = db.collection("matches").whereField("members", arrayContains: uid)
        query.getDocuments { (querySnapshot, err) in
            if let _ = err {
                completion(nil, "Error getting documents")
            } else {
                let dispatchGroup = DispatchGroup()
                for document in querySnapshot!.documents {
                    // Get the opposite uid
                    guard let membersArray = document.data()["members"] as? [String] else {continue}
                    let otherUid = (membersArray[0] == uid) ? membersArray[1] : membersArray[0]
                    dispatchGroup.enter()
                    Api.profiles.getProfileOf(uid: otherUid) { profile, error in
                        if let error = error {
                            completion(nil, error)
                        } else {
                            guard let profile = profile else { return }
                            if profileArray != nil {
                                profileArray?.append(profile)
                            } else {
                                profileArray = [profile]
                            }
                        }
                        dispatchGroup.leave()
                    }
                }
                dispatchGroup.notify(queue: DispatchQueue.main, execute: {
                    completion(profileArray, nil)
                })
            }
        }
    }
    
    /*
        func checkForMatchOnSwipeRight() {}
            This function is located online (it's called a "Cloud Function"), and it will automatically check if the person that someone swiped right on also swiped right them, in which case it will declare they are a "match" by adding a new document to the "matches" collection, in which they are "members" of that new document.
            The reason we have to do this outside the client code is we don’t want to let just anyone add entries to the `matches` collection, or else a malicious person could wreak havoc by matching random people together.
    */
}


