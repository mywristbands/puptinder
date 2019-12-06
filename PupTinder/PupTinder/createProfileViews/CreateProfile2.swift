//
//  CreateProfile2.swift
//  PupTinder
//
//  Created by Hajra Mobashar on 11/14/19.
//  Copyright © 2019 ecs189e. All rights reserved.
//

import UIKit

class CreateProfile2: UIViewController, UITextViewDelegate {
    

    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var bioContainerView: UIView!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var profImage: UIImage = UIImage()
    var name: String = ""
    var breed: String = ""
    var size: String = ""
    var gender: String = ""
    var bio: String = ""
    
    let swiftColor = UIColor(red: 256/256, green: 256/256, blue: 256/256, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bioTextView.delegate = self
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        self.bio = self.bioTextView.text
        if shouldPerformSegue(withIdentifier: "CP2ToCP3Segue", sender: nil) {
            self.performSegue(withIdentifier: "CP2ToCP3Segue", sender: nil)
        }
    }
    
    @IBAction func skipButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "CP2ToCP3SkipSegue", sender: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "CP2ToCP1Segue", sender: nil)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "CP2ToCP3Segue" && (self.bio == "" || self.bioTextView.text == "Type here to tell us more about your dog!") {
            return false
        }
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CP2ToCP3Segue" {
            if let destinationVC = segue.destination as? CreateProfile3 { //if the destination is what we want
                destinationVC.profImage = self.profImage
                destinationVC.name = self.name
                destinationVC.breed = self.breed
                destinationVC.size = self.size
                destinationVC.gender = self.gender
                destinationVC.bio = self.bio
            }
        } else if segue.identifier == "CP2ToCP3SkipSegue" {
            if let destinationVC = segue.destination as? CreateProfile3 { //if the destination is what we want
                destinationVC.profImage = self.profImage
                destinationVC.name = self.name
                destinationVC.breed = self.breed
                destinationVC.size = self.size
                destinationVC.gender = self.gender
            }
        } else if segue.identifier == "CP2ToCP1Segue" {
            if let destinationVC = segue.destination as? CreateProfile1 { //if the destination is what we want
                destinationVC.profImage = self.profImage
                destinationVC.name = self.name
                destinationVC.breed = self.breed
                destinationVC.size = self.size
                destinationVC.gender = self.gender
            }
        }
    }

}
