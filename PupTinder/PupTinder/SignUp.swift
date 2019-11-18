//
//  SignUp.swift
//  PupTinder
//
//  Created by Elias Heffan on 11/17/19.
//  Copyright © 2019 ecs189e. All rights reserved.
//

import UIKit

class SignUp: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // This is just a basic implementation for this function--will need to expand on it later
    func signUpPressed(){
        guard let email = emailField.text, let password = passwordField.text else {
            return
        }
        Api.signup(email: email, password: password) { (error) in
            if error != nil {
                self.errorField.text = error // display error
            } else {
                // TODO: Signup was a success, so Segueway to the next screen!
            }
        }
    }
}
