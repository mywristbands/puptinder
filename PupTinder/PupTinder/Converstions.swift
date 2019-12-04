//
//  Converstions.swift
//  PupTinder
//
//  Created by Hajra Mobashar on 12/1/19.
//  Copyright © 2019 ecs189e. All rights reserved.
//

import UIKit

class Converstions: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var matchesCollection: UICollectionView!
    
    var profilesArray: [Profile] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        Api.matches.getMatches() { profiles, error in
            if let error = error {
                print("getMatches failed: \(error)")
            } else {
                guard let profiles = profiles else {return}
                self.profilesArray = profiles
                self.matchesCollection.delegate = self
                self.matchesCollection.dataSource = self
                
                
                print("Print profiles now ... ")
                let profile = profiles[0]
                let profile1 = profiles[1]
                let profile2 = profiles[2]
                print(profile.name, profile.bio, profile.breed, profile.size, profile.characteristics, profile.traits)
                print(profile1.name, profile1.bio, profile1.breed, profile1.size, profile1.characteristics, profile1.traits)
                print(profile2.name, profile2.bio, profile2.breed, profile2.size, profile2.characteristics, profile2.traits)
            }
            dispatchGroup.leave()
           /* if error == nil {
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
            }*/
        }
        dispatchGroup.notify(queue: DispatchQueue.main, execute: {
            print("leaving")
            self.matchesCollection.reloadData()
            //self.matchesCollection.register(matchCollectionViewCell.self, forCellWithReuseIdentifier: "match")
        })
    }
    
    // Collection View Protocol
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return profilesArray?.count ?? 0
        print("!!\(profilesArray.count)")
        return profilesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "match", for: indexPath as IndexPath) as! matchCollectionViewCell
        //let image = self.profilesArray[indexPath.item].picture
        
        cell.matchProfileImage.image = self.profilesArray[indexPath.item].picture
        print(self.profilesArray[indexPath.item].picture)
        print(cell.matchProfileImage.image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50.0, height: 50.0)
    }

}

class MatchCell: UICollectionViewCell {
    fileprivate let img: UIImageView = {
        let iv = UIImageView()
        //iv.image = UIImage(named: "dog-icon") ?? UIImage()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
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
