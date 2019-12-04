//
//  OtherUserProfile.swift
//  PupTinder
//
//  Created by Hajra Mobashar on 12/3/19.
//  Copyright © 2019 ecs189e. All rights reserved.
//

import UIKit

class OtherUserProfile: UIViewController {
    
    var uid = ""

    override func viewDidLoad() {
        Api.profiles.getProfileOf(uid: uid) { profile, error in
            if(error != nil){
                print(error ?? "")
                return
            }
            
        }
        super.viewDidLoad()
    }

}
