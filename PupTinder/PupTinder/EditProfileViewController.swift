//
//  EditProfileViewController.swift
//  PupTinder
//
//  Created by Alannah Woodward on 11/23/19.
//  Copyright © 2019 ecs189e. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var breedTextField: UITextField!
    @IBOutlet weak var editPhotoButton: UIButton!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var editCharacteristicsButton: UIButton!
    @IBOutlet weak var editPersonalityButton: UIButton!
    @IBOutlet weak var characteristicsCV: UICollectionView!
    @IBOutlet weak var personalityCV: UICollectionView!
    @IBOutlet weak var genderButton: UIButton!
    @IBOutlet weak var sizeButton: UIButton!
    
    var profileCharacteristics: [String] = []
    var profileTraits: [String] = []
    var gender = ""
    var size = ""
    var imagePicker = UIImagePickerController()
    var bio: String = ""
    var fromEditingPT: Bool = false
    var fromEditingCH: Bool = false
    
    let white = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1).cgColor
    let yellow = UIColor(red: 255.0/255.0, green: 213.0/255.0, blue: 72.0/255.0, alpha: 1)
    let purple = UIColor(red: 130.0/255.0, green: 94.0/255.0, blue: 246.0/255.0, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.characteristicsCV.delegate = self
        self.characteristicsCV.dataSource = self
        self.personalityCV.delegate = self
        self.personalityCV.dataSource = self
        
        //setProfileImageStyle()

        Api.profiles.getProfile() { profile, error in
            if error == nil {
                self.profileImage.image = profile?.picture
                self.nameTextField.text = profile?.name
                self.breedTextField.text = profile?.breed
                if self.bio == "" {
                    self.bioTextView.text = profile?.bio
                } else {
                    self.bioTextView.text = self.bio
                }
                self.sizeButton.setBackgroundImage(self.getSizeImage(size: profile?.size ?? "", gender: profile?.gender ?? ""), for: UIControl.State.normal)
                self.size = profile?.size ?? "medium"
                self.genderButton.setBackgroundImage(self.getGenderImage(gender: profile?.gender ?? ""), for: UIControl.State.normal)
                if profile?.gender == "female" {
                    self.gender = "female"
                    self.genderButton.backgroundColor = self.purple
                    self.sizeButton.backgroundColor = self.purple
                } else {
                    self.gender = "male"
                    self.genderButton.backgroundColor = self.yellow
                    self.sizeButton.backgroundColor = self.yellow
                }
                if self.profileCharacteristics == [] { //&& !self.fromEditingCH{
                    self.profileCharacteristics = profile?.characteristics ?? []
                }
                if self.profileTraits == [] { //&& !self.fromEditingPT {
                    self.profileTraits = profile?.traits ?? []
                }
            self.characteristicsCV.register(CustomCell1.self, forCellWithReuseIdentifier: "cell")
            
                self.personalityCV.register(CustomCell1.self, forCellWithReuseIdentifier: "cell1")

                self.characteristicsCV.reloadData()
                self.personalityCV.reloadData()
            } else {
                print(error ?? "ERROR")
            }
        }
    }
    
    func setProfileImageStyle(){
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
        self.imageContainer.layer.shadowOpacity = 0.3
        
        self.sizeButton.clipsToBounds = true
        self.sizeButton.layer.cornerRadius = self.sizeButton.frame.height/2
        self.genderButton.clipsToBounds = true
        self.genderButton.layer.cornerRadius = self.genderButton.frame.height/2
    }
    
    @IBAction func pressedGenderButton() {
        if(gender == "female"){
            gender = "male"
            self.genderButton.setBackgroundImage(UIImage(named: "malePurpleProfile") ?? UIImage(), for: UIControl.State.normal)
        } else {
            gender = "female"
            genderButton.setBackgroundImage(UIImage(named: "femalePurpleProfile") ?? UIImage(), for: UIControl.State.normal)
        }
    }
    
    @IBAction func pressedSizeButton() {
        if(size == "small"){
            size = "medium"
            self.sizeButton.setBackgroundImage(UIImage(named: "mPurpleProfile") ?? UIImage(), for: UIControl.State.normal)
        } else if (size == "medium") {
            size = "large"
            self.sizeButton.setBackgroundImage(UIImage(named: "lPurpleProfile") ?? UIImage(), for: UIControl.State.normal)
        } else { //large
            size = "small"
            self.sizeButton.setBackgroundImage(UIImage(named: "sPurpleProfile") ?? UIImage(), for: UIControl.State.normal)
        }
    }
    
    
    @IBAction func editProfilePicture(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){

            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false

            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)

        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        self.profileImage.image = image
    }
    
    @IBAction func editCharacteristicsPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "EditToCharacteristicsSegue", sender: nil)
    }
    
    @IBAction func editPersonalityPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "EditToPersonalitySegue", sender: nil)
    }
    
    @IBAction func savebutton(_ sender: Any) {
        //print("before the Profile call")
        let profile1 = Profile(data: ["picture" : self.profileImage.image, "name" : self.nameTextField.text, "gender" : self.gender, "breed" : self.breedTextField.text, "size" : self.size, "bio" : self.bioTextView.text, "traits" : self.profileTraits, "characteristics" : self.profileCharacteristics])
        
        Api.profiles.uploadProfile(profile: profile1) { error in
            if error != nil {
                print(error ?? "ERROR")
                return
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let userProfileVC = storyboard.instantiateViewController(withIdentifier: "userProfile") as! UserProfile
            userProfileVC.modalPresentationStyle = .fullScreen
            self.present(userProfileVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        self.view.endEditing(true)
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
    
    func getCharacteristicImage(indexPath: IndexPath) -> UIImage {
        var image = UIImage()
        switch(self.profileCharacteristics[indexPath.row]) {
        case "Hypoallergenic":
            image = UIImage(named: "hypoallergenic") ?? UIImage()
            break
        case "Sheds a lot":
            image = UIImage(named: "sheds") ?? UIImage()
            break
        case "Kid friendly":
            image = UIImage(named: "kid-friendly") ?? UIImage()
            break
        case "Drool potential":
            image = UIImage(named: "drools") ?? UIImage()
            break
        case "Barks a lot":
            image = UIImage(named: "barks") ?? UIImage()
            break
        case "Pudgy":
            image = UIImage(named: "pudgy") ?? UIImage()
            break
        case "Hairless":
            image = UIImage(named: "hairless") ?? UIImage()
            break
        case "Fluffy":
            image = UIImage(named: "fluffy") ?? UIImage()
            break
        case "Tiny":
            image = UIImage(named: "tiny") ?? UIImage()
            break
        case "Tall":
            image = UIImage(named: "tall") ?? UIImage()
            break
        default:
            break
        }
        return image
    }

    func getPersonalityImage(indexPath: IndexPath) -> UIImage {
        var image = UIImage()
        switch(self.profileTraits[indexPath.row]) {
        case "Friendly":
            image = UIImage(named: "friendly") ?? UIImage()
            break
        case "Shy":
            image = UIImage(named: "shy") ?? UIImage()
            break
        case "Calm":
            image = UIImage(named: "calm") ?? UIImage()
            break
        case "Submissive":
            image = UIImage(named: "submissive") ?? UIImage()
            break
        case "Dominant":
            image = UIImage(named: "dominant") ?? UIImage()
            break
        case "Energetic":
            image = UIImage(named: "energetic") ?? UIImage()
            break
        case "Playful":
            image = UIImage(named: "playful") ?? UIImage()
            break
        case "Grumpy":
            image = UIImage(named: "grumpy") ?? UIImage()
            break
        case "Fun-loving":
            image = UIImage(named: "fun-loving") ?? UIImage()
            break
        case "Affectionate":
            image = UIImage(named: "affectionate") ?? UIImage()
            break
        case "Intelligent":
            image = UIImage(named: "intelligent") ?? UIImage()
            break
        case "Inquisitive":
            image = UIImage(named: "curious") ?? UIImage()
            break
        case "Fearless":
            image = UIImage(named: "brave") ?? UIImage()
            break
        default:
            break
        }
        return image
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.characteristicsCV {
            return self.profileCharacteristics.count
        } else {
            return self.profileTraits.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.characteristicsCV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! CustomCell1
            cell.img.image = getCharacteristicImage(indexPath: indexPath)
            return cell
        } else {
            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath as IndexPath) as! CustomCell1
            cell1.img.image = getPersonalityImage(indexPath: indexPath)
            return cell1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70.0, height: 70.0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditToCharacteristicsSegue" {
            if let destinationVC = segue.destination as? CreateProfile3 {
                //destinationVC.characteristics = self.profileCharacteristics
                destinationVC.fromEditProfile = true
            }
        } else if segue.identifier == "EditToPersonalitySegue" {
            if let destinationVC = segue.destination as? CreateProfile4 {
                //destinationVC.pickedPTraits = self.profileTraits
                destinationVC.fromEditProfile = true
            }
        }
    }
}

class CustomCell1: UICollectionViewCell {
    fileprivate let img: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(img)
        img.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        img.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        img.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        img.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
