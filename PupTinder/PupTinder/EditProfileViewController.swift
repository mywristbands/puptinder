//
//  EditProfileViewController.swift
//  PupTinder
//
//  Created by Alannah Woodward on 11/23/19.
//  Copyright © 2019 ecs189e. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var breedTextField: UITextField!
    @IBOutlet weak var editPhotoButton: UIButton!
    @IBOutlet weak var aboutNameLabel: UILabel!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var editCharacteristicsButton: UIButton!
    @IBOutlet weak var editPersonalityButton: UIButton!
    @IBOutlet weak var characteristicsCV: UICollectionView!
    @IBOutlet weak var personalityCV: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // need to get all profile information and put on screen
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
