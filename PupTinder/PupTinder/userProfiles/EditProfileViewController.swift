//
//  EditProfileViewController.swift
//  PupTinder
//
//  Created by Alannah Woodward on 11/23/19.
//  Copyright © 2019 ecs189e. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var breedTextField: UITextField!
    @IBOutlet weak var editPhotoButton: UIButton!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var editCharacteristicsButton: UIButton!
    @IBOutlet weak var editPersonalityButton: UIButton!
    @IBOutlet weak var characteristicsCV: UICollectionView!
    @IBOutlet weak var personalityCV: UICollectionView!
    @IBOutlet weak var sizeImage: UIImageView!
    @IBOutlet weak var genderImage: UIImageView!
    
    var profileCharacteristics: [String] = []
    var profileTraits: [String] = []
    
    let white = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1).cgColor
    let yellow = UIColor(red: 255.0/255.0, green: 213.0/255.0, blue: 72.0/255.0, alpha: 1)
    let purple = UIColor(red: 130.0/255.0, green: 94.0/255.0, blue: 246.0/255.0, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Api.profiles.getProfile() { profile, error in
            if error == nil {
                self.profileImage.image = profile?.picture
                self.nameTextField.text = profile?.name
                self.breedTextField.text = profile?.breed
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
                //self.characteristicsCV.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
                //self.personalityCV.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
                self.characteristicsCV.reloadData()
                self.personalityCV.reloadData()
            } else {
                print(error ?? "ERROR")
            }
        }
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
