//
//  Login.swift
//  PupTinder
//
//  Created by Hajra Mobashar on 11/9/19.
//  Copyright © 2019 ecs189e. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class Login: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginPressed() {
        guard let email = emailField.text, let password = passwordField.text else {
            return
        }
        Api.auth.login(email: email, password: password) { (error) in
            if error != nil {
                // TODO: Deal with the error
            } else {
                // TODO: Login was a success, so Segueway to the next screen!
            }
        }
    }
    
    // This function is just for testing matches; remove after matches functions are all working!
    func testSwipeRight() {
        let uids = ["0nE8qrJXBVYxtATnkXCHzSUw7jB2","45AXFdBoUld6OjG2tli64kC34VI3", "CT6zTIAip0NyVwpKwMCE115QfSk2", Api.matches.getUID()]
        for uid in uids {
            Api.matches.swipedRightOn(uid: uid) { error in
                if let error = error {
                    print(error)
                } else {
                    print("Successfully swiped right!")
                }
            }
        }
        let _ = Timer(timeInterval: 60, repeats: false) { _ in
            print("timer ended")
            Api.matches.getMatches() { profiles, error in
                if let error = error {
                    print(error)
                } else {
                    guard let profiles = profiles else {return}
                    for profile in profiles {
                        print("Found match: " + profile.name)
                    }
                }
            }
        }
    }
    
    // This function is just for testing matches; remove after matches functions are all working!
    func testingFunctionMatches() {
        Api.matches.getPotentialMatch{ (profile, error) in
            if let error = error {
                print(error)
            } else {
                guard let profile = profile else {return}
                print(profile.name, profile.bio, profile.breed, profile.size, profile.characteristics, profile.traits)
                let imageView = UIImageView(image: profile.picture)
                imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 200)
                self.view.addSubview(imageView)
            }
        }
    }
    
    // This function is just for testing matches array; remove after matches functions are all working!
    func testingFunctionMatchesArray() {
        Api.matches.getMatches{ (profiles, error) in
            if let error = error {
                print(error)
            } else {
                guard let profiles = profiles else {return}
                print("Print profiles now ... ")
                let profile = profiles[0]
                let profile1 = profiles[1]
                print(profile.name, profile.bio, profile.breed, profile.size, profile.characteristics, profile.traits)
                print(profile1.name, profile1.bio, profile1.breed, profile1.size, profile1.characteristics, profile1.traits)
                let imageView = UIImageView(image: profile.picture)
                imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 200)
                self.view.addSubview(imageView)
            }
        }
    }
    
    // This serves as a gateway to the Matches feature during development
    @IBAction func goToMatchesAndConversations() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let messengerVC = storyboard.instantiateViewController(withIdentifier: "MatchesAndConversations") as! MatchesAndConversations
        messengerVC.modalPresentationStyle = .fullScreen
        self.present(messengerVC, animated: true, completion: nil)
    }
    
}

