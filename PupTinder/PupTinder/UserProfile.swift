//
//  UserProfile.swift
//  PupTinder
//
//  Created by Alannah Woodward on 11/14/19.
//  Copyright © 2019 ecs189e. All rights reserved.
//

import UIKit

class UserProfile: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
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
    
    var characteristics:[String] = ["Hypoallergenic", "Sheds a lot", "Kid friendly", "Drool potential", "Barks a lot"]
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
    
    func getCharacteristicImage(indexPath: IndexPath) -> UIImage {
        var image = UIImage()
        switch(self.profileCharacteristics[indexPath.row]) {
        case "Hypoallergenic":
            image = UIImage(named: "dog-icon") ?? UIImage()
            break
        case "Sheds a lot":
            image = UIImage(named: "dog-icon") ?? UIImage()
            break
        case "Kid friendly":
            image = UIImage(named: "dog-icon") ?? UIImage()
            break
        case "Drool potential":
            image = UIImage(named: "dog-icon") ?? UIImage()
            break
        case "Barks a lot":
            image = UIImage(named: "dog-icon") ?? UIImage()
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
            image = UIImage(named: "dog-icon") ?? UIImage()
            break
        case "Shy":
            image = UIImage(named: "dog-icon") ?? UIImage()
            break
        case "Calm":
            image = UIImage(named: "dog-icon") ?? UIImage()
            break
        case "Submissive":
            image = UIImage(named: "dog-icon") ?? UIImage()
            break
        case "Dominant":
            image = UIImage(named: "dog-icon") ?? UIImage()
            break
        case "Energetic":
            image = UIImage(named: "dog-icon") ?? UIImage()
            break
        case "Playful":
            image = UIImage(named: "dog-icon") ?? UIImage()
            break
        case "Grumpy":
            image = UIImage(named: "dog-icon") ?? UIImage()
            break
        case "Fun-loving":
            image = UIImage(named: "dog-icon") ?? UIImage()
            break
        case "Affectionate":
            image = UIImage(named: "dog-icon") ?? UIImage()
            break
        case "Intelligent":
            image = UIImage(named: "dog-icon") ?? UIImage()
            break
        case "Inquisitive":
            image = UIImage(named: "dog-icon") ?? UIImage()
            break
        case "Fearless":
            image = UIImage(named: "dog-icon") ?? UIImage()
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! CustomCell
        
        if collectionView == self.characteristicsCV {
            cell.bg.image = getCharacteristicImage(indexPath: indexPath)
        } else {
            cell.bg.image = getPersonalityImage(indexPath: indexPath)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.4, height: collectionView.frame.height * 0.4)
    }
}

class CustomCell: UICollectionViewCell {
    fileprivate let bg: UIImageView = {
        let iv = UIImageView()
        //iv.image = UIImage(named: "dog-icon") ?? UIImage()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(bg)
        bg.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        bg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        bg.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        bg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
