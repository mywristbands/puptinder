//
//  ProfileViewController.swift
//  PupTinder
//
//  Created by Alannah Woodward on 11/11/19.
//  Copyright © 2019 ecs189e. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var smallDogIcon: UIButton!
    @IBOutlet weak var medDogIcon: UIButton!
    @IBOutlet weak var largeDogIcon: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var userProfilePhoto: UIImageView!
    @IBOutlet weak var editPhotoButton: UIButton!
    
    @IBOutlet weak var characteristicsTV: UITableView!
    @IBOutlet weak var personalityTV: UITableView!
    
    
    var dogSize : String = ""
    let swiftColor = UIColor(red: 130/256, green: 94/256, blue: 246/256, alpha: 1)
    
    var characteristics:[String] = ["Hypoallergenic", "Sheds a lot", "Kid friendly", "Drool potential", "Barks a lot"];
    var personalityTraits:[String] = ["Friendly", "Shy", "Calm", "Submissive", "Dominant", "Energetic", "Playful", "Grumpy", "Fun-loving", "Affectionate", "Intelligent", "Inquisitive", "Fearless"];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.characteristicsTV.dataSource = self
        self.characteristicsTV.delegate = self
        self.personalityTV.dataSource = self
        self.personalityTV.delegate = self
        
        femaleButton.layer.masksToBounds = true
        femaleButton.layer.cornerRadius = femaleButton.frame.width/2
        
        maleButton.layer.masksToBounds = true
        maleButton.layer.cornerRadius = maleButton.frame.width/2
        
        userProfilePhoto.layer.masksToBounds = true;
        userProfilePhoto.layer.cornerRadius = userProfilePhoto.frame.width/2;
        
        self.characteristicsTV.allowsMultipleSelection = true
        self.personalityTV.allowsMultipleSelection = true
        self.characteristicsTV.reloadData()
        self.personalityTV.reloadData()
    }
    
    @IBAction func logoutButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(identifier: "loginViewController") as! ViewController
        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: true, completion: nil)
    }
    
    
    @IBAction func smallSizePressed(_ sender: Any) {
        if smallDogIcon.backgroundColor == UIColor.white {
            if medDogIcon.backgroundColor == swiftColor {
                medDogIcon.backgroundColor = UIColor.white
            } else if largeDogIcon.backgroundColor == swiftColor {
                largeDogIcon.backgroundColor = UIColor.white
            }
            
            smallDogIcon.backgroundColor = swiftColor
            self.dogSize = "small"
        } else { //unselect the dog
            smallDogIcon.backgroundColor = UIColor.white
            dogSize = "unselected"
        }
    }
    
    @IBAction func medSizePressed(_ sender: Any) {
        if medDogIcon.backgroundColor == UIColor.white {
            if smallDogIcon.backgroundColor == swiftColor {
                smallDogIcon.backgroundColor = UIColor.white
            } else if largeDogIcon.backgroundColor == swiftColor {
                largeDogIcon.backgroundColor = UIColor.white
            }
            
            medDogIcon.backgroundColor = swiftColor
            self.dogSize = "medium"
        } else { //unselect the dog
            medDogIcon.backgroundColor = UIColor.white
            dogSize = "unselected"
        }
    }
    
    @IBAction func largeSizePressed(_ sender: Any) {
        if largeDogIcon.backgroundColor == UIColor.white {
            if smallDogIcon.backgroundColor == swiftColor {
                smallDogIcon.backgroundColor = UIColor.white
            } else if medDogIcon.backgroundColor == swiftColor {
                medDogIcon.backgroundColor = UIColor.white
            }
            
            largeDogIcon.backgroundColor = swiftColor
            self.dogSize = "large"
        } else { //unselect the dog
            largeDogIcon.backgroundColor = UIColor.white
            dogSize = "unselected"
        }
    }
    
    @IBAction func femaleButtonPressed(_ sender: Any) {
        if femaleButton.backgroundColor == UIColor.white {
            if maleButton.backgroundColor == swiftColor {
                maleButton.backgroundColor = UIColor.white
            }
            
            femaleButton.backgroundColor = swiftColor
        } else {
            femaleButton.backgroundColor = UIColor.white
        }
    }
    
    @IBAction func maleButtonPressed(_ sender: Any) {
        if maleButton.backgroundColor == UIColor.white {
            if femaleButton.backgroundColor == swiftColor {
                femaleButton.backgroundColor = UIColor.white
            }
            
            maleButton.backgroundColor = swiftColor
        } else {
            maleButton.backgroundColor = UIColor.white
        }
    }
    
    //MARK: Table View Implementation
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == self.characteristicsTV) {
            return characteristics.count
        } else if(tableView == self.personalityTV) {
            return personalityTraits.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == self.characteristicsTV)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Characteristic cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Characteristic cell")
            
            let characteristic = String(format: "%@", self.characteristics[indexPath.row])
            cell.textLabel?.text = "\(characteristic)"
            
            
            cell.imageView?.image = UIImage(named: "unchecked")
            
            cell.isUserInteractionEnabled = true
            return cell
        } else if(tableView == self.personalityTV) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Personality cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Personality cell")
            let pt = String(format: "%@", self.personalityTraits[indexPath.row])
            cell.textLabel?.text = "\(pt)"
            
            cell.imageView?.image = UIImage(named: "unchecked")
            
            cell.isUserInteractionEnabled = true
            return cell
        }
        
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if(cell?.imageView?.image ?? UIImage() == UIImage(named:"unchecked")) {
            cell?.imageView?.image = UIImage(named:"checked") ?? UIImage()
        } else {
            cell?.imageView?.image = UIImage(named:"unchecked") ?? UIImage()
        }
    }
}
