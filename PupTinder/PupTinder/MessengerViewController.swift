//
//  MessengerViewController.swift
//  PupTinder
//
//  Created by Tammy Lee on 11/9/19.
//  Copyright © 2019 ecs189e. All rights reserved.
//

import UIKit
import Firebase

class MessengerViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signupPressed() {
        guard let email = emailField.text, let password = passwordField.text else {
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
          if error != nil {
              print("Failed to sign up")
              return
          }
        }
    }
    
    @IBAction func signinPressed() {
        guard let email = emailField.text, let password = passwordField.text else {
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
            if error != nil {
                print("Failed to sign in")
                return
            }
          // If user successfully signs in, get account data from results object that's passed to the callback method
        }
    }
}
