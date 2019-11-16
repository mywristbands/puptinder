//
//  CreateProfile2.swift
//  PupTinder
//
//  Created by Hajra Mobashar on 11/14/19.
//  Copyright © 2019 ecs189e. All rights reserved.
//

import UIKit

class CreateProfile2: UIViewController {
    

    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var bioContainerView: UIView!
    
    let swiftColor = UIColor(red: 256/256, green: 256/256, blue: 256/256, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // bioTextView.layer.borderColor = swiftColor.cgColor
      //  bioTextView.layer.borderWidth = 1.0
        
       /* bioContainerView.layer.shadowColor = UIColor.black.cgColor
        bioContainerView.layer.shadowOpacity = 0.6
        bioContainerView.layer.shadowOffset = CGSize(width: 25, height: 1)
        bioContainerView.layer.shadowRadius = 5
        bioContainerView.layer.shadowPath = UIBezierPath(rect: bioTextView.bounds).cgPath
        bioContainerView.layer.shouldRasterize = true
        */
        
    }

}
