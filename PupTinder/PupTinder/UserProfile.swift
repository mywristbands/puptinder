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
    @IBOutlet weak var imageContianer: UIView!
    
    let white = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1).cgColor
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.profileImage.layer.cornerRadius = self.profileImage.frame.height/2
        self.profileImage.clipsToBounds = true
        
        self.imageContianer.layer.cornerRadius = self.imageContianer.frame.height/2
        
       self.imageContianer.layer.shadowPath =
              UIBezierPath(roundedRect: self.imageContianer.bounds,
              cornerRadius: self.imageContianer.layer.cornerRadius).cgPath
        self.imageContianer.layer.shadowColor = UIColor.black.cgColor
        self.imageContianer.layer.shadowOpacity = 0.3
        self.imageContianer.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.imageContianer.layer.shadowRadius = 5
        self.imageContianer.clipsToBounds = false
        
        self.sizeImage.clipsToBounds = true
        self.sizeImage.layer.cornerRadius = self.sizeImage.frame.height/2
        self.genderImage.clipsToBounds = true
        self.genderImage.layer.cornerRadius = self.genderImage.frame.height/2
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
