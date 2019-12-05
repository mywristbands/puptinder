//
//  UserProfile.swift
//  PupTinder
//
//  Created by Alannah Woodward on 11/14/19.
//  Copyright © 2019 ecs189e. All rights reserved.
//

import UIKit

class UserProfile: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var characteristics:[String] = ["Hypoallergenic", "Sheds a lot", "Kid friendly", "Drool potential", "Barks a lot", "Pudgy", "Hairless", "Fluffy", "Tiny", "Tall"]
    var personalityTraits:[String] = ["Friendly", "Shy", "Calm", "Submissive", "Dominant", "Energetic", "Playful", "Grumpy", "Fun-loving", "Affectionate", "Intelligent", "Inquisitive", "Fearless"]
    
    var profileCharacteristics: [String] = []
    var profileTraits: [String] = []
    
    let white = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1).cgColor
    let yellow = UIColor(red: 255.0/255.0, green: 213.0/255.0, blue: 72.0/255.0, alpha: 1)
    let purple = UIColor(red: 130.0/255.0, green: 94.0/255.0, blue: 246.0/255.0, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.characteristicsCV.delegate = self
        self.characteristicsCV.dataSource = self
        self.personalityCV.delegate = self
        self.personalityCV.dataSource = self
        
        settingsView.isHidden = true
        settingsView.isUserInteractionEnabled = false
        settingsView.layer.cornerRadius = 10
        
        setProfileImageStyle()

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
                self.personalityCV.register(CustomCell.self, forCellWithReuseIdentifier: "cell1")
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
    
    @IBAction func settingsPressed(_ sender: Any) {
        settingsView.isHidden = false
        settingsView.isUserInteractionEnabled = true
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        _ = Api.auth.logout()
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        settingsView.isHidden = true
        settingsView.isUserInteractionEnabled = false
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
    
    // Collection View Protocol
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.characteristicsCV {
            return self.profileCharacteristics.count
        } else {
            return self.profileTraits.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.characteristicsCV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! CustomCell
            cell.img.image = getCharacteristicImage(indexPath: indexPath)
             return cell
        } else {
            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath as IndexPath) as! CustomCell
            cell1.img.image = getPersonalityImage(indexPath: indexPath)
            return cell1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70.0, height: 70.0)
    }
    
}

class CustomCell: UICollectionViewCell {
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
