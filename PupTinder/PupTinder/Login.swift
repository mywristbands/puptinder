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
                
                // These functions are just for testing; remove after profile stuff is all working!
                //self.uploadProfile()
                //self.testGetProfile()
                //self.testingFunction()
                //print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
                //self.testingFunctionMatches()
                //self.testingFunctionMatchesArray()
            }
        }
    }
    
    // This function is just for testing; remove after profile stuff is all working!
    func uploadProfile(){
        Api.profiles.uploadProfile(profile: Profile(picture: UIImage(named: "test_dog")!, name: "Elias", gender: "male", breed: "SuperHuman", size: "small", bio: "Why isn't upload profile working?", traits: ["impatient"], characteristics: ["In my room", "here"])) {
            (error) in
            if (error != nil) {
                print(error!)
            }
        }
    }
    // This function is just for testing; remove after profile stuff is all working!
    func testGetProfile() {
        Api.profiles.getProfile { (profile, error) in
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
    
    // This function is just for testing; remove after profile stuff is all working!
    func testingFunction() {
        Api.profiles.getProfileOf(uid: "HfPac5bFtmODf4YSZuuPZ76BBgH2") { (profile, error) in
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

