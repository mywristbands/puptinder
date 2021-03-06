//
//  CreateProfile3.swift
//  PupTinder
//
//  Created by Hajra Mobashar on 11/14/19.
//  Copyright © 2019 ecs189e. All rights reserved.
//

import UIKit

class CreateProfile3: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
     @IBOutlet weak var characteristicsTV: UITableView!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var characteristics: [String] = ["Hypoallergenic", "Sheds a lot", "Kid friendly", "Drool potential", "Barks a lot", "Pudgy", "Hairless", "Fluffy", "Tiny", "Tall"]
    var profImage: UIImage = UIImage()
    var name: String = ""
    var breed: String = ""
    var size: String = ""
    var gender: String = ""
    var bio: String = ""
    var pickedCharacteristics: [String] = []
    var fromEditProfile = false

    override func viewDidLoad() {
        self.characteristicsTV.dataSource = self
        self.characteristicsTV.delegate = self
        super.viewDidLoad()
        self.characteristicsTV.reloadData()
        self.characteristicsTV.allowsMultipleSelection = true
        print("in load")
        print(self.characteristics)
        
        if fromEditProfile {
            self.skipButton.isHidden = true
            self.backButton.isHidden = true
        }
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        if let list = characteristicsTV.indexPathsForSelectedRows {
            if list.count > 0 {
                guard let indexPaths = self.characteristicsTV.indexPathsForSelectedRows else { // if no selected cells just return
                  return
                }

                for indexPath in indexPaths {
                    pickedCharacteristics.append(characteristics[indexPath.row])
                }
                
                if fromEditProfile {
                    Api.profiles.getProfile() { profile, error in
                        if error == nil {
                            let profile1 = Profile(data: ["picture" : profile?.picture, "name" : profile?.name, "gender" : profile?.gender, "breed" : profile?.breed, "size" : profile?.size, "bio" : profile?.bio, "traits" : profile?.traits, "characteristics" : self.pickedCharacteristics])
                            Api.profiles.uploadProfile(profile: profile1) { error in
                                if error != nil {
                                    print(error ?? "ERROR")
                                    return
                                } else {
                                    self.performSegue(withIdentifier: "CharacteristicsToEditSegue", sender: nil)
                                }
                            }
                        }
                    }
                    //self.performSegue(withIdentifier: "CharacteristicsToEditSegue", sender: nil)
                } else {
                    self.performSegue(withIdentifier: "CP3ToCP4Segue", sender: nil)
                }
            }
        }
        if fromEditProfile {
            Api.profiles.getProfile() { profile, error in
                if error == nil {
                    let profile1 = Profile(data: ["picture" : profile?.picture, "name" : profile?.name, "gender" : profile?.gender, "breed" : profile?.breed, "size" : profile?.size, "bio" : profile?.bio, "traits" : profile?.traits, "characteristics" : self.pickedCharacteristics])
                    Api.profiles.uploadProfile(profile: profile1) { error in
                        if error != nil {
                            print(error ?? "ERROR")
                            return
                        } else {
                            self.performSegue(withIdentifier: "CharacteristicsToEditSegue", sender: nil)
                        }
                    }
                }
            }
            //self.performSegue(withIdentifier: "CharacteristicsToEditSegue", sender: nil)
        }
    }
    
    @IBAction func skipButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "CP3ToCP4SkipSegue", sender: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "CP3ToCP2Segue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.characteristics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Characteristic cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Characteristic cell")
        
        let characteristic = String(format: "%@", self.characteristics[indexPath.row])
        cell.textLabel?.text = "\(characteristic)"
        
        if(cell.imageView?.image != UIImage(named: "checked1"))
        {
            cell.imageView?.image = UIImage(named: "unchecked2")
        }
        
        cell.isUserInteractionEnabled = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if(cell?.imageView?.image ?? UIImage() == UIImage(named:"unchecked2")) {
            cell?.imageView?.image = UIImage(named:"checked1") ?? UIImage()
        } else {
            cell?.imageView?.image = UIImage(named:"unchecked2") ?? UIImage()
        }
    }
    
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        let cell = tableView.cellForRow(at: indexPath)
        if(cell?.imageView?.image ?? UIImage() == UIImage(named:"unchecked2")) {
            cell?.imageView?.image = UIImage(named:"checked1") ?? UIImage()
        } else {
            cell?.imageView?.image = UIImage(named:"unchecked2") ?? UIImage()
        }
        
        return indexPath
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CP3ToCP4Segue" {
            if let destinationVC = segue.destination as? CreateProfile4 { //if the destination is what we want
                destinationVC.profImage = self.profImage
                destinationVC.name = self.name
                destinationVC.breed = self.breed
                destinationVC.size = self.size
                destinationVC.gender = self.gender
                destinationVC.bio = self.bio
                destinationVC.pickedCharacteristics = self.pickedCharacteristics
            }
        } else if segue.identifier == "CP3ToCP4SkipSegue" {
            if let destinationVC = segue.destination as? CreateProfile4 { //if the destination is what we want
                destinationVC.profImage = self.profImage
                destinationVC.name = self.name
                destinationVC.breed = self.breed
                destinationVC.size = self.size
                destinationVC.gender = self.gender
                destinationVC.bio = self.bio
            }
        } else if segue.identifier == "CP3ToCP2Segue" {
            if let destinationVC = segue.destination as? CreateProfile2 { //if the destination is what we want
                destinationVC.profImage = self.profImage
                destinationVC.name = self.name
                destinationVC.breed = self.breed
                destinationVC.size = self.size
                destinationVC.gender = self.gender
                destinationVC.bio = self.bio
            }
        } /*else if segue.identifier == "CharacteristicsToEditSegue" {
            if let destinationVC = segue.destination as? EditProfileViewController { //if the destination is what we want
                //destinationVC.profileCharacteristics = self.pickedCharacteristics
                //print(self.pickedCharacteristics)
            }
        }*/
    }

}
