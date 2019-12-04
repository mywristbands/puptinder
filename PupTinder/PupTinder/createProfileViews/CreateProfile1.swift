//
//  ProfileViewController.swift
//  PupTinder
//
//  Created by Alannah Woodward on 11/11/19.
//  Copyright © 2019 ecs189e. All rights reserved.
//

import UIKit

class CreateProfile1: UIViewController, UIImagePickerControllerDelegate ,UINavigationControllerDelegate {
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var smallDogIcon: UIButton!
    @IBOutlet weak var medDogIcon: UIButton!
    @IBOutlet weak var largeDogIcon: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var userProfilePhoto: UIImageView!
    @IBOutlet weak var editPhotoButton: UIButton!
    @IBOutlet weak var dogNameTextField: UITextField!
    @IBOutlet weak var dogBreedTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var breedGuessView: UIView!
    @IBOutlet weak var ImageContainer: UIView!
    
    var imagePicker = UIImagePickerController()
    
    // variables we need to pass to the next view controller and keep passing until the very end of profile creation
    var profImage: UIImage = UIImage(named: "profile-dog") ?? UIImage()
    var name: String = ""
    var breed: String = ""
    var size : String = ""
    var gender: String = ""
    
    let swiftColor = UIColor(red: 130/256, green: 94/256, blue: 246/256, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.isHidden = true
        userProfilePhoto.image = profImage
        breedGuessView.isHidden = true
        breedGuessView.layer.cornerRadius = 10
        
        femaleButton.layer.masksToBounds = true
        femaleButton.layer.cornerRadius = femaleButton.frame.width/2
        
        maleButton.layer.masksToBounds = true
        maleButton.layer.cornerRadius = maleButton.frame.width/2
        
        userProfilePhoto.layer.masksToBounds = true;
        userProfilePhoto.layer.cornerRadius = userProfilePhoto.frame.width/2;
        
         self.ImageContainer.layer.cornerRadius = self.ImageContainer.frame.height/2
         
        self.ImageContainer.layer.shadowPath =
               UIBezierPath(roundedRect: self.ImageContainer.bounds,
               cornerRadius: self.ImageContainer.layer.cornerRadius).cgPath
         self.ImageContainer.layer.shadowColor = UIColor.black.cgColor
         self.ImageContainer.layer.shadowOpacity = 0.3
         self.ImageContainer.layer.shadowOffset = CGSize(width: 2, height: 2)
         self.ImageContainer.layer.shadowRadius = 5
         self.ImageContainer.clipsToBounds = false
        
    }
    
    @IBAction func editPhotoPressed(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){

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
        self.profImage = image
        
        // This function is just for testing; remove after profile stuff is all working!
        //eliasTestingFunction(image)
        
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
                    if((breed as? String ?? "") != "not found") {
                        self.dogBreedTextField.text = breed as? String ?? ""
                        self.size = size as? String ?? ""
                        
                        switch(self.size)
                        {
                            case "small":
                                self.smallSizePressedGen()
                                break
                            case "medium":
                                self.medSizePressedGen()
                                break
                            case "large":
                                self.largeSizePressedGen()
                                break
                            default:
                                break
                        }
                    }
                    
                    self.errorLabel.isHidden = true
                    self.breedGuessView.isHidden = true
                    self.activityIndicator.stopAnimating()
                    self.view.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    @IBAction func logoutButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "loginViewController") as! Login
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
            self.size = "small"
        } else { //unselect the dog
            smallDogIcon.backgroundColor = UIColor.white
            self.size = ""
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
            self.size = "medium"
        } else { //unselect the dog
            medDogIcon.backgroundColor = UIColor.white
            self.size = ""
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
            self.size = "large"
        } else { //unselect the dog
            largeDogIcon.backgroundColor = UIColor.white
            self.size = ""
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
            self.gender = "female"
        } else {
            femaleButton.backgroundColor = UIColor.white
            self.gender = ""
        }
    }
    
    @IBAction func maleButtonPressed(_ sender: Any) {
        if maleButton.backgroundColor == UIColor.white {
            if femaleButton.backgroundColor == swiftColor {
                femaleButton.backgroundColor = UIColor.white
            }
            
            maleButton.backgroundColor = swiftColor
            self.gender = "male"
        } else {
            maleButton.backgroundColor = UIColor.white
            self.gender = ""
        }
    }
    @IBAction func logoutPressed() {
        if let errorMessage = Api.auth.logout() {
            // If logout fails, send and alert to user.
            let alertController = UIAlertController(title: "Logout failed", message: errorMessage, preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        self.name = dogNameTextField.text ?? ""
        self.breed = dogBreedTextField.text ?? ""
        
        if(errorCheck()) { //if no errors
            self.errorLabel.isHidden = true
            self.performSegue(withIdentifier: "CP1ToCP2Segue", sender: nil)
        } else {
            self.errorLabel.isHidden = false
        }
    }
    
    func errorCheck() -> Bool {
        if(self.profImage == UIImage(named: "profile-dog")) {
            errorLabel.text = "Please choose an image"
            return false
        }
        
        if(self.breed == "") {
            errorLabel.text = "Please enter a breed"
            return false
        }
        
        if(self.name == "") {
            errorLabel.text = "Please enter a name"
            return false
        }
        
        if(self.size == "") {
            errorLabel.text = "Please choose a size"
            return false
        }
        
        if(self.gender == "") {
            errorLabel.text = "Please choose an gender"
            return false
        }
        
        return true
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "CP1ToCP2Segue" && (self.profImage == UIImage() || self.profImage == UIImage(named: "profile-dog") || self.breed == "" || self.name == "" || self.size == "" || self.gender == "") {
            return false
        }
        
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CP1ToCP2Segue" && !(self.profImage == UIImage() || self.profImage == UIImage(named: "profile-dog") || self.breed == "" || self.name == "" || self.size == "" || self.gender == "") {
            if let destinationVC = segue.destination as? CreateProfile2 { //if the destination is what we want
                destinationVC.profImage = self.profImage
                destinationVC.name = self.name
                destinationVC.breed = self.breed
                destinationVC.size = self.size
                destinationVC.gender = self.gender
            }
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
