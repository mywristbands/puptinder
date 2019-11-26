//
//  CreateProfile3.swift
//  PupTinder
//
//  Created by Hajra Mobashar on 11/14/19.
//  Copyright © 2019 ecs189e. All rights reserved.
//

import UIKit

class CreateProfile3: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
     @IBOutlet weak var characteristicsTV: UITableView!
    
    var characteristics:[String] = ["Hypoallergenic", "Sheds a lot", "Kid friendly", "Drool potential", "Barks a lot"];
    var profImage: UIImage = UIImage()
    var name: String = ""
    var breed: String = ""
    var size: String = ""
    var gender: String = ""
    var bio: String = ""
    var pickedCharacteristics: [String] = []

    override func viewDidLoad() {
        self.characteristicsTV.dataSource = self
        self.characteristicsTV.delegate = self
        super.viewDidLoad()
        self.characteristicsTV.reloadData()
        self.characteristicsTV.allowsMultipleSelection = true
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        if let list = characteristicsTV.indexPathsForSelectedRows {
            if list.count > 0 {
                guard let indexPaths = self.characteristicsTV.indexPathsForSelectedRows else { // if no selected cells just return
                  return
                }

                for indexPath in indexPaths {
                    pickedCharacteristics.append(characteristics[indexPath.row])
                }
                
                self.performSegue(withIdentifier: "CP3ToCP4Segue", sender: nil)
            }
        }
    }
    
    @IBAction func skipButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "CP3ToCP4SkipSegue", sender: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "CP3ToCP2Segue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characteristics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Characteristic cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Characteristic cell")
        
        let characteristic = String(format: "%@", self.characteristics[indexPath.row])
        cell.textLabel?.text = "\(characteristic)"
        
        if(cell.imageView?.image != UIImage(named: "checked"))
        {
            cell.imageView?.image = UIImage(named: "unchecked")
        }
        
        cell.isUserInteractionEnabled = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if(cell?.imageView?.image ?? UIImage() == UIImage(named:"unchecked")) {
            cell?.imageView?.image = UIImage(named:"checked") ?? UIImage()
        } else {
            cell?.imageView?.image = UIImage(named:"unchecked") ?? UIImage()
        }
    }
    
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        let cell = tableView.cellForRow(at: indexPath)
        if(cell?.imageView?.image ?? UIImage() == UIImage(named:"unchecked")) {
            cell?.imageView?.image = UIImage(named:"checked") ?? UIImage()
        } else {
            cell?.imageView?.image = UIImage(named:"unchecked") ?? UIImage()
        }
        
        return indexPath
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CP3ToCP4Segue" {
            if let destinationVC = segue.destination as? CreateProfile4 { //if the destination is what we want
                destinationVC.profImage = self.profImage
                destinationVC.name = self.name
                destinationVC.breed = self.breed
                destinationVC.size = self.size
                destinationVC.gender = self.gender
                destinationVC.bio = self.bio
                destinationVC.pickedCharacteristics = self.pickedCharacteristics
            }
        } else if segue.identifier == "CP3ToCP4SkipSegue" {
            if let destinationVC = segue.destination as? CreateProfile4 { //if the destination is what we want
                destinationVC.profImage = self.profImage
                destinationVC.name = self.name
                destinationVC.breed = self.breed
                destinationVC.size = self.size
                destinationVC.gender = self.gender
                destinationVC.bio = self.bio
            }
        } else if segue.identifier == "CP3ToCP2Segue" {
            if let destinationVC = segue.destination as? CreateProfile2 { //if the destination is what we want
                destinationVC.profImage = self.profImage
                destinationVC.name = self.name
                destinationVC.breed = self.breed
                destinationVC.size = self.size
                destinationVC.gender = self.gender
                destinationVC.bio = self.bio
            }
        }
    }

}
