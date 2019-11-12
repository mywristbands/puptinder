//
//  ProfileViewController.swift
//  PupTinder
//
//  Created by Alannah Woodward on 11/11/19.
//  Copyright © 2019 ecs189e. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var smallDogIcon: UIButton!
    @IBOutlet weak var medDogIcon: UIButton!
    @IBOutlet weak var largeDogIcon: UIButton!
    
    var dogSize : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func smallSizePressed(_ sender: Any) {
        if smallDogIcon.backgroundColor == UIColor.white {
            if medDogIcon.backgroundColor == UIColor.black {
                medDogIcon.backgroundColor = UIColor.white
            } else if largeDogIcon.backgroundColor == UIColor.black {
                largeDogIcon.backgroundColor = UIColor.white
            }
            
            smallDogIcon.backgroundColor = UIColor.black
            self.dogSize = "small"
        } else { //unselect the dog
            smallDogIcon.backgroundColor = UIColor.white
            dogSize = "unselected"
        }
    }
    
    @IBAction func medSizePressed(_ sender: Any) {
        if medDogIcon.backgroundColor == UIColor.white {
            if smallDogIcon.backgroundColor == UIColor.black {
                smallDogIcon.backgroundColor = UIColor.white
            } else if largeDogIcon.backgroundColor == UIColor.black {
                largeDogIcon.backgroundColor = UIColor.white
            }
            
            medDogIcon.backgroundColor = UIColor.black
            self.dogSize = "medium"
        } else { //unselect the dog
            medDogIcon.backgroundColor = UIColor.white
            dogSize = "unselected"
        }
    }
    
    @IBAction func largeSizePressed(_ sender: Any) {
        if largeDogIcon.backgroundColor == UIColor.white {
            if smallDogIcon.backgroundColor == UIColor.black {
                smallDogIcon.backgroundColor = UIColor.white
            } else if medDogIcon.backgroundColor == UIColor.black {
                medDogIcon.backgroundColor = UIColor.white
            }
            
            largeDogIcon.backgroundColor = UIColor.black
            self.dogSize = "large"
        } else { //unselect the dog
            largeDogIcon.backgroundColor = UIColor.white
            dogSize = "unselected"
        }
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
