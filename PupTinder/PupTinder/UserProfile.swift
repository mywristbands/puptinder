//
//  UserProfile.swift
//  PupTinder
//
//  Created by Alannah Woodward on 11/14/19.
//  Copyright © 2019 ecs189e. All rights reserved.
//

import UIKit

class UserProfile: UIViewController {
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var sizeImage: UIImageView!
    @IBOutlet weak var genderImage: UIImageView!
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var aboutNameLabel: UILabel!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var characteristicsCV: UICollectionView!
    @IBOutlet weak var personalityCV: UICollectionView!
    
    //var userProfile: Profile = Profile(data: ["picture" : "", "name" : "", "gender" : "", "breed" : "", "size" : "", "bio" : "", "traits" : [], "characteristics" : []])
    
    let white = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1).cgColor
    let yellow = UIColor(red: 255.0/255.0, green: 213.0/255.0, blue: 72.0/255.0, alpha: 1)
    let purple = UIColor(red: 130.0/255.0, green: 94.0/255.0, blue: 246.0/255.0, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Api.profiles.getProfile() { profile, error in
            if error == nil {
                //self.userProfile = profile ?? Profile(data: ["picture" : "", "name" : "", "gender" : "", "breed" : "", "size" : "", "bio" : "", "traits" : [], "characteristics" : []])
                self.profileImage.image = profile?.picture//self.userProfile.picture
                self.nameLabel.text = profile?.name//self.userProfile.name
                self.breedLabel.text = profile?.breed//self.userProfile.breed
                self.aboutNameLabel.text = "About \(profile?.name ?? "Mr Woofer")" //About \(self.userProfile.name)"
                self.bioTextView.text = profile?.bio//self.userProfile.bio
                self.sizeImage.image = self.getSizeImage(size: profile?.size ?? "", gender: profile?.gender ?? "")//self.getSizeImage(size: self.userProfile.size, gender: self.userProfile.gender)
                self.genderImage.image = self.getGenderImage(gender: profile?.gender ?? "")//self.getGenderImage(gender: self.userProfile.gender)
                if profile?.gender == "female" {
                    self.genderImage.backgroundColor = self.purple
                    self.sizeImage.backgroundColor = self.purple
                } else {
                    self.genderImage.backgroundColor = self.yellow
                    self.sizeImage.backgroundColor = self.yellow
                }
                /*if self.userProfile.gender == "female" {
                    self.genderImage.backgroundColor = self.purple
                    self.sizeImage.backgroundColor = self.purple
                } else {
                    self.genderImage.backgroundColor = self.yellow
                    self.sizeImage.backgroundColor = self.yellow
                }*/
            } else {
                print(error ?? "ERROR")
            }
        }
        
        self.profileImage.layer.cornerRadius = self.profileImage.frame.height/2
        self.profileImage.clipsToBounds = true
        
        self.imageContainer.layer.cornerRadius = self.imageContainer.frame.height/2
        
       self.imageContainer.layer.shadowPath =
              UIBezierPath(roundedRect: self.imageContainer.bounds,
              cornerRadius: self.imageContainer.layer.cornerRadius).cgPath
        self.imageContainer.layer.shadowColor = UIColor.black.cgColor
        self.imageContainer.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.imageContainer.layer.shadowRadius = 5
        self.imageContainer.clipsToBounds = false
        
        self.sizeImage.clipsToBounds = true
        self.sizeImage.layer.cornerRadius = self.sizeImage.frame.height/2
        self.genderImage.clipsToBounds = true
        self.genderImage.layer.cornerRadius = self.genderImage.frame.height/2
    }
    
    func getSizeImage(size: String, gender: String) -> UIImage {
        var image = UIImage()
        if size != "" && gender != "" {
            switch(gender) {
                case "female":
                    switch(size) {
                        case "small":
                            image = UIImage(named: "sYellowProfile") ?? UIImage()
                            break
                        case "medium":
                            image = UIImage(named: "mYellowProfile") ?? UIImage()
                            break
                        case "large":
                            image = UIImage(named: "lYellowProfile") ?? UIImage()
                            break
                        default:
                            break
                    }
                    break
                case "male":
                    switch(size) {
                        case "small":
                            image = UIImage(named: "sPurpleProfile") ?? UIImage()
                            break
                        case "medium":
                            image = UIImage(named: "mPurpleProfile") ?? UIImage()
                            break
                        case "large":
                            image = UIImage(named: "lPurpleProfile") ?? UIImage()
                            break
                        default:
                            break
                    }
                    break
                default:
                    break
            }
            return image
        } else {
            return UIImage(named: "lPurpleProfile") ?? UIImage()
        }
    }
    
    func getGenderImage(gender: String) -> UIImage {
        if gender != "" {
            var image = UIImage()
            switch(gender) {
                case "female":
                    image = UIImage(named: "femaleYellowProfile") ?? UIImage()
                    break
                case "male":
                    image = UIImage(named: "malePurpleProfile") ?? UIImage()
                    break
                default:
                    break
            }
            return image
        } else {
            return UIImage(named: "malePurpleProfile") ?? UIImage()
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        setGradientBackGround()
    }
    
    func setGradientBackGround()
    {
        let colorLeft =  UIColor(red: 255.0/255.0, green: 213.0/255.0, blue: 72.0/255.0, alpha: 0.70).cgColor
        let colorRight = UIColor(red: 254.0/255.0, green: 186.0/255.0, blue: 41.0/255.0, alpha: 0.70).cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorLeft, colorRight]
        gradientLayer.frame = self.view.bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5);
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5);

        self.backgroundImage.layer.insertSublayer(gradientLayer, at: 0)
    }

}
