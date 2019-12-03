//
//  MatchesAndConversations.swift
//  PupTinder
//
//  Created by Elias Heffan on 11/17/19.
//  Copyright © 2019 ecs189e. All rights reserved.
//

import UIKit

class MatchesAndConversations: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var matchesCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        matchesCollection.delegate = self
        matchesCollection.dataSource = self
    }

    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "matchCell", for: indexPath) as! matchCollectionViewCell
        cell.matchLabel.text = "String(indexPath.row)"
        return cell
    }
    
    
}
