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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.profileImage.layer.cornerRadius = self.profileImage.frame.height/2;
        self.profileImage.clipsToBounds = true;
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
