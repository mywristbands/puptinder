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
    
    func loginPressed() {
        guard let email = emailField.text, let password = passwordField.text else {
            return
        }
        Api.login(email: email, password: password) { (error) in
            if error != nil {
                // TODO: Deal with the error
            } else {
                // TODO: Login was a success, so Segueway to the next screen!
            }
        }
    }
    
    // This serves as a gateway to the Matches feature during development
    @IBAction func goToMatchesAndConversations() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let messengerVC = storyboard.instantiateViewController(identifier: "MatchesAndConversations") as! MatchesAndConversations
        messengerVC.modalPresentationStyle = .fullScreen
        self.present(messengerVC, animated: true, completion: nil)
    }
    
}

