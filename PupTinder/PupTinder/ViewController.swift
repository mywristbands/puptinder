//
//  ViewController.swift
//  PupTinder
//
//  Created by Hajra Mobashar on 11/9/19.
//  Copyright © 2019 ecs189e. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    
    // This serves as a gateway to the messaging feature during development
    @IBAction func goToMessaging() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let messengerVC = storyboard.instantiateViewController(identifier: "messenger") as! MessengerViewController
        messengerVC.modalPresentationStyle = .fullScreen
        self.present(messengerVC, animated: true, completion: nil)
    }
    
}

