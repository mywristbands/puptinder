//
//  ApiAuthing.swift
//  PupTinder
//
//  Created by Elias Heffan on 11/24/19.
//  Copyright © 2019 ecs189e. All rights reserved.
//

import Foundation
import Firebase

class Authing {
    
    private func getAuthErrorCode(_ error: Error?) -> AuthErrorCode? {
        let nsError = error as NSError?
        guard let errorCode = nsError?.code else {return nil}
        return AuthErrorCode(rawValue: errorCode)
    }
    
    /// Signs new user up.
    /// - Parameter completion: If successful, completion's `error` argument will be `nil`, else it will contain a `Optional(String)` describing the error for now it just always says "Failed to sign up").
    func signup(email: String, password: String, completion: @escaping ((_ error: String?) -> Void)) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            guard let errorCode = self.getAuthErrorCode(error) else {
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
    func login(email: String, password: String, completion: @escaping ((_ error: String?) -> Void)) {
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            
            guard let errorCode = self.getAuthErrorCode(error) else {
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
    func logout() -> String? {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            return String(format: "Error signing out: %@", signOutError)
        }
        return nil
    }

}
