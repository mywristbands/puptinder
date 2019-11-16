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

    override func viewDidLoad() {
        self.characteristicsTV.dataSource = self
        self.characteristicsTV.delegate = self
        super.viewDidLoad()
        self.characteristicsTV.reloadData()
        self.characteristicsTV.allowsMultipleSelection = true
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characteristics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Characteristic cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Characteristic cell")
        
        let characteristic = String(format: "%@", self.characteristics[indexPath.row])
        cell.textLabel?.text = "\(characteristic)"
        
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
