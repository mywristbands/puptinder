//
//  ProfileApi.swift
//  PupTinder
//
//  Created by Elias Heffan on 11/24/19.
//  Copyright © 2019 ecs189e. All rights reserved.
//

import Foundation
import Firebase

struct Profile {
    var picture: UIImage
    var name: String
    var gender: String
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
        gender = data["gender"] as? String ?? ""
        breed = data["breed"] as? String ?? ""
        size = data["size"] as? String ?? ""
        bio = data["bio"] as? String ?? ""
        traits = data["traits"] as? [String] ?? []
        characteristics = data["characteristics"] as? [String] ?? []
    }
}

class Profiles: ApiShared {
    let storage = Storage.storage().reference()
    
    private func getStorageErrorCode(_ error: Error?) -> StorageErrorCode? {
        let nsError = error as NSError?
        guard let errorCode = nsError?.code else {return nil}
        return StorageErrorCode(rawValue: errorCode)
    }
        
    /// Uploads new profile for current user, or overwrites existing profile if user has already created a profile.
    /// - Parameter completion: If successful, completion's `error` argument will be `nil`, else it will contain a `Optional(String)` describing the error.
    func uploadProfile(profile: Profile, completion: @escaping ((_ error: String?) -> Void)) {
        
        guard let filepath = uploadProfilePicture(profile.picture) else {
            print("Could not prepare profile picture for upload")
            return
        }
       
        // Upload profile
        db.collection("profiles").document(getUID()).setData(
            ["picture":filepath,"name":profile.name,"gender":profile.gender,"breed":profile.breed,"size":profile.size,"bio":profile.bio,"traits":profile.traits,"characteristics":profile.characteristics])
    }
        
    func uploadProfilePicture(_ picture: UIImage) -> String? {
        
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
     */
    func getProfile(completion: @escaping ((_ profile: Profile?, _ error: String?) -> Void)) {
        getProfileOf(uid: getUID(), completion: completion)
    }
    
    /**
        Gets the profile of any specified user.
        - Parameter uid: the uid of the user whose profile we want to get.
        - Parameter completion: If successful, completion's `error` argument will be `nil`, else it will contain a `Optional(String)` describing the error.
     
        You might want to use this function to get another user's name, like when messaging someone.
     
         Possible error strings include:
         "Profile doesn't have a profile picture!"
         "Profile picture is too big to download."
         "Couldn't get profile picture for an unknown reason."
         "Profile was never created."
    */
    func getProfileOf(uid: String, completion: @escaping ((_ profile: Profile?, _ error: String?) -> Void)) {
        getProfilePicture(uid) { (image, error) in
            // Now that we have attempted to get our profile picture...
            
            // Complete with error if error occurred in getting profile picture
            if let error = error {
                completion(nil, error)
            }
            
            // Otherwise, get the rest of the Profile info
            let profileLocation = self.db.collection("profiles").document(uid)

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
    
    private func getProfilePicture(_ uid: String, completion: @escaping ((_ image: UIImage?, _ error: String?) -> Void)) -> Void {
        
        let profilePicLocation = storage.child("profilePictures/" + uid)

        // Download pic to memory with a maximum allowed size of 1MB
        profilePicLocation.getData(maxSize: 1 * 1024 * 1024) { data, error in
            guard let errorCode = self.getStorageErrorCode(error) else {
                // No error occurred!
                guard let data = data else {return}
                completion(UIImage(data: data), nil)
                return
            }
            
            switch (errorCode) {
            case .objectNotFound:
                completion(nil, "Profile doesn't have a profile picture!")
            case .downloadSizeExceeded:
                completion(nil, "Profile picture is too big to download.")
            default:
                completion(nil, "Couldn't get profile picture for an unknown reason.")
            }
        }
    }
}
