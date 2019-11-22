//
//  CreateProfile2.swift
//  PupTinder
//
//  Created by Hajra Mobashar on 11/14/19.
//  Copyright © 2019 ecs189e. All rights reserved.
//

import UIKit

class CreateProfile2: UIViewController, UITextViewDelegate {
    

    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var bioContainerView: UIView!
    
    let swiftColor = UIColor(red: 256/256, green: 256/256, blue: 256/256, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bioTextView.delegate = self
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }

}
