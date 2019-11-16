//
//  CreateProfile4.swift
//  PupTinder
//
//  Created by Hajra Mobashar on 11/14/19.
//  Copyright © 2019 ecs189e. All rights reserved.
//

import UIKit

class CreateProfile4: UIViewController,UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var personalityTV: UITableView!
        var personalityTraits:[String] = ["Friendly", "Shy", "Calm", "Submissive", "Dominant", "Energetic", "Playful", "Grumpy", "Fun-loving", "Affectionate", "Intelligent", "Inquisitive", "Fearless"];

    override func viewDidLoad() {
        super.viewDidLoad()
        self.personalityTV.dataSource = self
        self.personalityTV.delegate = self
        self.personalityTV.allowsMultipleSelection = true
        self.personalityTV.reloadData()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personalityTraits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Personality cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Personality cell")
        let pt = String(format: "%@", self.personalityTraits[indexPath.row])
        cell.textLabel?.text = "\(pt)"
        
        cell.imageView?.image = UIImage(named: "unchecked")
        
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
}
