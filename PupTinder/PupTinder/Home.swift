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
        super.viewDidLoad()
        styleTile()
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
    
    @IBAction func xButton(_ sender: UIButton) {
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
    
    @IBAction func loveButton(_ sender: UIButton) {
        print(uid)
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
        Api.matches.getMatches() { profiles, error in
            print(profiles ?? ["no profiles"])
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
