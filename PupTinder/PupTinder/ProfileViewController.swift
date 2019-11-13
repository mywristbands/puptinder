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
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
    
    var dogSize : String = ""
    let swiftColor = UIColor(red: 130/256, green: 94/256, blue: 246/256, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*smallDogIcon.layer.masksToBounds = true
        smallDogIcon.layer.cornerRadius = smallDogIcon.frame.width/1.5
        
        medDogIcon.layer.masksToBounds = true
        medDogIcon.layer.cornerRadius = medDogIcon.frame.width/1.5
        
        largeDogIcon.layer.masksToBounds = true
        largeDogIcon.layer.cornerRadius = largeDogIcon.frame.width/1.5*/
        
        
        femaleButton.layer.masksToBounds = true
        femaleButton.layer.cornerRadius = femaleButton.frame.width/2
        
        maleButton.layer.masksToBounds = true
        maleButton.layer.cornerRadius = maleButton.frame.width/2

    }
    
    @IBAction func smallSizePressed(_ sender: Any) {
        if smallDogIcon.backgroundColor == UIColor.white {
            if medDogIcon.backgroundColor == swiftColor {
                medDogIcon.backgroundColor = UIColor.white
            } else if largeDogIcon.backgroundColor == swiftColor {
                largeDogIcon.backgroundColor = UIColor.white
            }
            
            smallDogIcon.backgroundColor = swiftColor
            self.dogSize = "small"
        } else { //unselect the dog
            smallDogIcon.backgroundColor = UIColor.white
            dogSize = "unselected"
        }
    }
    
    @IBAction func medSizePressed(_ sender: Any) {
        if medDogIcon.backgroundColor == UIColor.white {
            if smallDogIcon.backgroundColor == swiftColor {
                smallDogIcon.backgroundColor = UIColor.white
            } else if largeDogIcon.backgroundColor == swiftColor {
                largeDogIcon.backgroundColor = UIColor.white
            }
            
            medDogIcon.backgroundColor = swiftColor
            self.dogSize = "medium"
        } else { //unselect the dog
            medDogIcon.backgroundColor = UIColor.white
            dogSize = "unselected"
        }
    }
    
    @IBAction func largeSizePressed(_ sender: Any) {
        if largeDogIcon.backgroundColor == UIColor.white {
            if smallDogIcon.backgroundColor == swiftColor {
                smallDogIcon.backgroundColor = UIColor.white
            } else if medDogIcon.backgroundColor == swiftColor {
                medDogIcon.backgroundColor = UIColor.white
            }
            
            largeDogIcon.backgroundColor = swiftColor
            self.dogSize = "large"
        } else { //unselect the dog
            largeDogIcon.backgroundColor = UIColor.white
            dogSize = "unselected"
        }
    }
    
    @IBAction func femaleButtonPressed(_ sender: Any) {
        if femaleButton.backgroundColor == UIColor.white {
            femaleButton.backgroundColor = swiftColor
        }
    }
    
    @IBAction func maleButtonPressed(_ sender: Any) {
    }
}
