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
    
    @IBOutlet weak var personalityTV: UITableView!
    var personalityTraits:[String] = ["Friendly", "Shy", "Calm", "Submissive", "Dominant", "Energetic", "Playful", "Grumpy", "Fun-loving", "Affectionate", "Intelligent", "Inquisitive", "Fearless"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.personalityTV.dataSource = self
        self.personalityTV.delegate = self
        self.personalityTV.allowsMultipleSelection = true
        self.personalityTV.reloadData()
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
        
        if(cell.imageView?.image != UIImage(named: "checked"))
        {
            cell.imageView?.image = UIImage(named: "unchecked")
        }
        
        cell.isUserInteractionEnabled = true
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if(cell?.imageView?.image ?? UIImage() == UIImage(named:"unchecked")) {
            cell?.imageView?.image = UIImage(named:"checked") ?? UIImage()
        } else {
            cell?.imageView?.image = UIImage(named:"unchecked") ?? UIImage()
        }
    }
    
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        let cell = tableView.cellForRow(at: indexPath)
        if(cell?.imageView?.image ?? UIImage() == UIImage(named:"unchecked")) {
            cell?.imageView?.image = UIImage(named:"checked") ?? UIImage()
        } else {
            cell?.imageView?.image = UIImage(named:"unchecked") ?? UIImage()
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
        }
    }
}
