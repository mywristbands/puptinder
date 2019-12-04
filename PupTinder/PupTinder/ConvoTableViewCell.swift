//
//  ConvoTableViewCell.swift
//  PupTinder
//
//  Created by Tammy Lee on 12/3/19.
//  Copyright © 2019 ecs189e. All rights reserved.
//

import UIKit

class ConvoTableViewCell: UITableViewCell {
    @IBOutlet weak var convoPic: UIImageView!
    @IBOutlet weak var convoNameLabel: UILabel!
    @IBOutlet weak var convoMessageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.convoPic.setRounded()
        // Configure the view for the selected state
    }
}

extension UIImageView {

    func setRounded() {
        self.layer.cornerRadius = (self.frame.width / 2) //instead of let radius = CGRectGetWidth(self.frame) / 2
        self.layer.masksToBounds = true
    }
}
