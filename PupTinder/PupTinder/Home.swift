//
//  Home.swift
//  PupTinder
//
//  Created by Hajra Mobashar on 11/21/19.
//  Copyright © 2019 ecs189e. All rights reserved.
//

import UIKit

class Home: UIViewController {
    
    @IBOutlet weak var dogProfileImage: UIImageView!
    @IBOutlet weak var dogName: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var breed: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleTile()
        Api.matches.getPotentialMatch(){ matchProfile, error in
            if(error != nil){
                return
            }
            self.dogName.text = matchProfile?.name
            self.dogProfileImage.image = matchProfile?.picture
            self.breed.text = matchProfile?.breed
        }
    }
    
    @IBAction func xButton(_ sender: UIButton) {
        Api.matches.getPotentialMatch(){ matchProfile, error in
            if(error != nil){
                return
            }
            self.dogName.text = matchProfile?.name
            self.dogProfileImage.image = matchProfile?.picture
            self.breed.text = matchProfile?.breed
        }
    }
    
    @IBAction func loveButton(_ sender: UIButton) {
    }
    
    @IBAction func messagesButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let conversationsVC = storyboard.instantiateViewController(withIdentifier: "conversations") as! Converstions
        conversationsVC.modalPresentationStyle = .fullScreen
        self.present(conversationsVC, animated: true, completion: nil)
    }
    
    @IBAction func logoutButton(_ sender: UIButton) {
        /*
        if Api.auth.logout() != nil {
            print("Error logging out")
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "loginViewController") as! Login
        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: true, completion: nil)
 */
    }
    
    func styleTile(){
        self.containerView.layer.cornerRadius = 5
        self.containerView.layer.shadowPath = UIBezierPath(roundedRect: self.containerView.bounds,
        cornerRadius: self.containerView.layer.cornerRadius).cgPath
        self.containerView.layer.shadowColor = UIColor.black.cgColor
        self.containerView.layer.shadowOpacity = 0.7
        self.containerView.layer.shadowOffset = CGSize(width: 25, height: 25)
        self.containerView.layer.shadowRadius = 25
    }
    
    /*
    Api.profiles.getProfile() { profile, error in
        if error == nil {
            self.profileImage.image = profile?.picture
            self.nameLabel.text = profile?.name
            self.breedLabel.text = profile?.breed
            self.aboutNameLabel.text = "About \(profile?.name ?? "Mr Woofer")"
            self.bioTextView.text = profile?.bio
            self.sizeImage.image = self.getSizeImage(size: profile?.size ?? "", gender: profile?.gender ?? "")
            self.genderImage.image = self.getGenderImage(gender: profile?.gender ?? "")
            if profile?.gender == "female" {
                self.genderImage.backgroundColor = self.purple
                self.sizeImage.backgroundColor = self.purple
            } else {
                self.genderImage.backgroundColor = self.yellow
                self.sizeImage.backgroundColor = self.yellow
            }
            self.profileCharacteristics = profile?.characteristics ?? []
            self.profileTraits = profile?.traits ?? []
            self.characteristicsCV.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
            self.personalityCV.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
            self.characteristicsCV.reloadData()
            self.personalityCV.reloadData()
        } else {
            print(error ?? "ERROR")
        }
    }
 */
}
