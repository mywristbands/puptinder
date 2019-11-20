//
//  ProfileViewController.swift
//  PupTinder
//
//  Created by Alannah Woodward on 11/11/19.
//  Copyright © 2019 ecs189e. All rights reserved.
//

import UIKit

class CreateProfile1: UIViewController, UIImagePickerControllerDelegate ,UINavigationControllerDelegate/*, UIImagePickerControllerDelegate*/ {
    @IBOutlet weak var smallDogIcon: UIButton!
    @IBOutlet weak var medDogIcon: UIButton!
    @IBOutlet weak var largeDogIcon: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var userProfilePhoto: UIImageView!
    @IBOutlet weak var editPhotoButton: UIButton!
    @IBOutlet weak var dogBreedTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var breedGuessView: UIView!
    var imagePicker = UIImagePickerController()
    var profImage = UIImage(named: "profile-dog")
    var dogID: String = ""
    var dogBreed: String = ""
    
    
    var dogSize : String = ""
    let swiftColor = UIColor(red: 130/256, green: 94/256, blue: 246/256, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userProfilePhoto.image = profImage
        breedGuessView.isHidden = true
        
        femaleButton.layer.masksToBounds = true
        femaleButton.layer.cornerRadius = femaleButton.frame.width/2
        
        maleButton.layer.masksToBounds = true
        maleButton.layer.cornerRadius = maleButton.frame.width/2
        
        userProfilePhoto.layer.masksToBounds = true;
        userProfilePhoto.layer.cornerRadius = userProfilePhoto.frame.width/2;
        
    }
    
    @IBAction func editPhotoPressed(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")

            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false

            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)

        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage

        userProfilePhoto.image = image
        
        let imageURL = info[UIImagePickerController.InfoKey.imageURL] as! URL
        let imageName = imageURL.lastPathComponent
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let localPath = documentDirectory.stringByAppendingPathComponent(path: imageName)

        let data = image.pngData()
        do {
            try data?.write(to: URL(fileURLWithPath: localPath), options: .atomic)
        } catch let error {
            print(error)
        }

        let imageData = NSData(contentsOfFile: localPath)!
        let photoURL = NSURL(fileURLWithPath: localPath)
        _ = UIImage(data: imageData as Data)!
        
        _ = URL(string: "https://api.thedogapi.com/v1/images/upload")
        let param = [
            "file"  : photoURL
        ]

        breedGuessView.isHidden = false
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        myImageUploadRequest(profImage: image, param: param)
        { picID in
            getDogBreed(pictureID: picID as? String ?? "")
            { breed, size  in
                DispatchQueue.main.async {
                    self.dogBreedTextField.text = breed as? String ?? ""
                    self.dogSize = size as? String ?? ""
                    
                    switch(self.dogSize)
                    {
                        case "small":
                            self.smallSizePressed(nil)
                            break
                        case "medium":
                            self.medSizePressed(nil)
                            break
                        case "large":
                            self.largeSizePressed(nil)
                            break
                        default:
                            break
                    }
                    
                    self.breedGuessView.isHidden = true
                    self.activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    @IBAction func logoutButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(identifier: "loginViewController") as! Login
        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: true, completion: nil)
    }
    
    
    func smallSizePressedGen() {
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
    
    @IBAction func smallSizePressed(_ sender: Any?) {
        smallSizePressedGen()
    }
    
    func medSizePressedGen() {
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
    
    @IBAction func medSizePressed(_ sender: Any?) {
        medSizePressedGen()
    }
    
    func largeSizePressedGen() {
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
    
    @IBAction func largeSizePressed(_ sender: Any?) {
        largeSizePressedGen()
    }
    
    @IBAction func femaleButtonPressed(_ sender: Any) {
        if femaleButton.backgroundColor == UIColor.white {
            if maleButton.backgroundColor == swiftColor {
                maleButton.backgroundColor = UIColor.white
            }
            
            femaleButton.backgroundColor = swiftColor
        } else {
            femaleButton.backgroundColor = UIColor.white
        }
    }
    
    @IBAction func maleButtonPressed(_ sender: Any) {
        if maleButton.backgroundColor == UIColor.white {
            if femaleButton.backgroundColor == swiftColor {
                femaleButton.backgroundColor = UIColor.white
            }
            
            maleButton.backgroundColor = swiftColor
        } else {
            maleButton.backgroundColor = UIColor.white
        }
    }

}

extension String {

    var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }
    var pathExtension: String {
        return (self as NSString).pathExtension
    }
    var stringByDeletingLastPathComponent: String {
        return (self as NSString).deletingLastPathComponent
    }
    var stringByDeletingPathExtension: String {
        return (self as NSString).deletingPathExtension
    }
    var pathComponents: [String] {
        return (self as NSString).pathComponents
    }
    func stringByAppendingPathComponent(path: String) -> String {
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }
    func stringByAppendingPathExtension(ext: String) -> String? {
        let nsSt = self as NSString
        return nsSt.appendingPathExtension(ext)
    }
}
