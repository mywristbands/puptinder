//
//  Converstions.swift
//  PupTinder
//
//  Created by Hajra Mobashar on 12/1/19.
//  Copyright © 2019 ecs189e. All rights reserved.
//

import UIKit

class Converstions: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var matchesCollection: UICollectionView!
    
    let test = ["match1","match2","match3","match4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.matchesCollection.delegate = self
        self.matchesCollection.dataSource = self
        self.matchesCollection.reloadData()
    }
    
    // Collection View Protocol
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("returning count")
        return test.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "match", for: indexPath as IndexPath) as! matchCollectionViewCell
        //cell.matchProfileImage.text = test[indexPath.item]
        //cell.backgroundColor = UIColor.black
        print("returning cell")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("returning size")
        return CGSize(width: 50.0, height: 50.0)
    }

}

class MatchCell: UICollectionViewCell {
    fileprivate let img: UIImageView = {
        let iv = UIImageView()
        //iv.image = UIImage(named: "dog-icon") ?? UIImage()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(img)
        img.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        img.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        img.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        img.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
