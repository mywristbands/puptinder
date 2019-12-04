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
    
    var uid = ""
    
    override func viewDidLoad() {
        
        Api.matches.getPotentialMatch(){ matchProfile, error in
            if(error != nil){
                print(error ?? "")
                return
            }
            self.dogName.text = matchProfile?.name
            self.dogProfileImage.image = matchProfile?.picture
            self.breed.text = matchProfile?.breed
            self.uid = matchProfile?.uid ?? ""
        }
        super.viewDidLoad()
        styleTile()
    }
    
    @IBAction func selectProfileButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let otherProfileVC = storyboard.instantiateViewController(withIdentifier: "otherUserProfile") as! OtherUserProfile
        otherProfileVC.modalPresentationStyle = .fullScreen
        otherProfileVC.uid = uid
        self.present(otherProfileVC, animated: true, completion: nil)
    }
    
    
    @IBAction func xButton(_ sender: UIButton) {
        //dogProfileImage.loadGif(name: "loading-gif")
        Api.matches.getPotentialMatch(){ matchProfile, error in
            if(error != nil){
                print(error ?? "")
                return
            }
            self.dogName.text = matchProfile?.name
            self.dogProfileImage.image = matchProfile?.picture
            self.breed.text = matchProfile?.breed
            self.uid = matchProfile?.uid ?? ""
        }
    }
    
    @IBAction func loveButton(_ sender: UIButton) {
        //dogProfileImage.loadGif(name: "loading-gif")
        dogProfileImage.startAnimating()
        Api.matches.swipedRightOn(uid: uid) { error in
            if(error != nil){
                print(error ?? "")
                return
            }
        }
        Api.matches.getPotentialMatch(){ matchProfile, error in
            if(error != nil){
                return
            }
            self.dogName.text = matchProfile?.name
            self.dogProfileImage.image = matchProfile?.picture
            self.breed.text = matchProfile?.breed
            self.uid = matchProfile?.uid ?? ""
        }
    }
    
    @IBAction func messagesButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let conversationsVC = storyboard.instantiateViewController(withIdentifier: "conversations") as! Converstions
        conversationsVC.modalPresentationStyle = .fullScreen
        self.present(conversationsVC, animated: true, completion: nil)
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
    
}
