//
//  CreateProfile4.swift
//  PupTinder
//
//  Created by Hajra Mobashar on 11/14/19.
//  Copyright © 2019 ecs189e. All rights reserved.
//

import UIKit

class CreateProfile4: UIViewController,UITableViewDataSource, UITableViewDelegate {
    var profImage: UIImage = UIImage()
    var name: String = ""
    var breed: String = ""
    var size: String = ""
    var gender: String = ""
    var bio: String = ""
    var pickedCharacteristics: [String] = []
    var pickedPTraits: [String] = []
    var fromEditProfile = false
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var personalityTV: UITableView!
    @IBOutlet weak var createProfileButton: UIButton!
    
    var personalityTraits:[String] = ["Friendly", "Shy", "Calm", "Submissive", "Dominant", "Energetic", "Playful", "Grumpy", "Fun-loving", "Affectionate", "Intelligent", "Inquisitive", "Fearless"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.personalityTV.dataSource = self
        self.personalityTV.delegate = self
        self.personalityTV.allowsMultipleSelection = true
        self.personalityTV.reloadData()
        
        /*if fromEditProfile {
            createProfileButton.setTitle("Continue", for: .normal)
            backButton.isHidden = true
            for trait in self.pickedPTraits {
                //print("trait:")
                //print(trait)
                //self.personalityTraits.firstIndex(of: trait)
                for cell in self.personalityTV.visibleCells { //THIS IS WRONG, NEED TO LOOK THROUGH ALL CELLS BUT CANT?
                    if cell.textLabel?.text == trait {
                        //print("text:")
                        //print(cell.textLabel?.text)
                        let indP = self.personalityTV.indexPath(for: cell)
                        self.personalityTV.selectRow(at: indP, animated: true, scrollPosition: UITableView.ScrollPosition.middle)
                    }
                }
                //self.personalityTV.selectRow(at: <#T##IndexPath?#>, animated: true, scrollPosition: UITableView.ScrollPosition.middle)
            }
        }*/
        
        if fromEditProfile {
            createProfileButton.setTitle("Continue", for: .normal)
            backButton.isHidden = true
        }
    }
    
    @IBAction func createProfileButtonPressed(_ sender: Any) {
        if let list = personalityTV.indexPathsForSelectedRows {
            if list.count > 0 {
                guard let indexPaths = self.personalityTV.indexPathsForSelectedRows else { // if no selected cells just return
                  return
                }

                for indexPath in indexPaths {
                    pickedPTraits.append(personalityTraits[indexPath.row])
                }
            }
        }
        
        if fromEditProfile {
            Api.profiles.getProfile() { profile, error in
                if error == nil {
                    let profile1 = Profile(data: ["picture" : profile?.picture, "name" : profile?.name, "gender" : profile?.gender, "breed" : profile?.breed, "size" : profile?.size, "bio" : profile?.bio, "traits" : self.pickedPTraits, "characteristics" : profile?.characteristics])
                    Api.profiles.uploadProfile(profile: profile1) { error in
                        if error != nil {
                            print(error ?? "ERROR")
                            return
                        } else {
                            self.performSegue(withIdentifier: "PersonalityToEditSegue", sender: nil)
                        }
                    }
                }
            }
            //self.performSegue(withIdentifier: "PersonalityToEditSegue", sender: nil)
        } else {
            let profile1 = Profile(data: ["picture" : self.profImage, "name" : self.name, "gender" : self.gender, "breed" : self.breed, "size" : self.size, "bio" : self.bio, "traits" : self.pickedPTraits, "characteristics" : self.pickedCharacteristics])
            
            Api.profiles.uploadProfile(profile: profile1) {
                error in
                if error == nil {
                    self.performSegue(withIdentifier: "CP4ToUPSegue", sender: nil)
                } else {
                    print(error ?? "ERROR")
                }
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "CP4ToCP3Segue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personalityTraits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Personality cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Personality cell")
        let pt = String(format: "%@", self.personalityTraits[indexPath.row])
        cell.textLabel?.text = "\(pt)"
        
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
        if segue.identifier == "CP4ToCP3Segue" {
            if let destinationVC = segue.destination as? CreateProfile3 { //if the destination is what we want
                destinationVC.profImage = self.profImage
                destinationVC.name = self.name
                destinationVC.breed = self.breed
                destinationVC.size = self.size
                destinationVC.gender = self.gender
                destinationVC.bio = self.bio
                destinationVC.pickedCharacteristics = self.pickedCharacteristics
            }
        } /*else if segue.identifier == "PersonalityToEditSegue" {
            if let destinationVC = segue.destination as? EditProfileViewController {
                destinationVC.profileTraits = self.pickedPTraits
            }
        }*/
    }
}
