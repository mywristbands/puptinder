//
//  Converstions.swift
//  PupTinder
//
//  Created by Hajra Mobashar on 12/1/19.
//  Copyright © 2019 ecs189e. All rights reserved.
//

import UIKit

class Converstions: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var matchesCollection: UICollectionView!
    @IBOutlet weak var conversationsTV: UITableView!
    @IBOutlet weak var loadingImage: UIImageView!
    @IBOutlet weak var profilePopUp: UIView!
    
    var profilesArray: [Profile] = []
    var conversationsInfoArray: [ConversationInfo] = []
    var uid = ""
    override func viewDidLoad() {
        loadingImage.isHidden = false
        loadingImage.loadGif(name: "sending")
        profilePopUp.isHidden = true
        super.viewDidLoad()
        self.matchesCollection.delegate = self
        self.matchesCollection.dataSource = self
        self.conversationsTV.delegate = self
        self.conversationsTV.dataSource = self
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        Api.matches.getMatches() { profiles, error in
            if let error = error {
                print("getMatches failed: \(error)")
            } else {
                guard let profiles = profiles else {
                    dispatchGroup.leave()
                    return
                }
                self.profilesArray = profiles
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        Api.messages.getConversationsInfo() { conversationsInfo, error in
            if let error = error {
                print("getConversationsInfo failed: \(error)")
            } else {
                guard let conversationsInfo = conversationsInfo else {
                    dispatchGroup.leave()
                    return
                }
                self.conversationsInfoArray = conversationsInfo
            }
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: DispatchQueue.main, execute: {
            self.matchesCollection.reloadData()
            self.conversationsTV.reloadData()
            self.loadingImage.isHidden = true
        })
        
        
    }
    @IBAction func homeButtonPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        profilePopUp.isHidden = true
    }
    
    @IBAction func viewProfileButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileVC = storyboard.instantiateViewController(withIdentifier: "userProfile") as! UserProfile
        profileVC.modalPresentationStyle = .fullScreen
        profileVC.uid = uid
        profileVC.messaging = true
        self.present(profileVC, animated: true, completion: nil)
    }
    
    @IBAction func startTalkingButton(_ sender: Any) {
    }
    
    
    // Collection View Protocol for Matches
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profilesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "match", for: indexPath as IndexPath) as! matchCollectionViewCell
        cell.matchProfileImage.setRounded()
        cell.matchProfileImage.contentMode = .scaleAspectFill
        cell.matchProfileImage.image = self.profilesArray[indexPath.item].picture
        cell.nameLabel.text = self.profilesArray[indexPath.item].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50.0, height: 50.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.profilePopUp.isHidden = false
        profilePopUp.center = view.center
        profilePopUp.alpha = 1
        profilePopUp.transform = CGAffineTransform(scaleX: 0.8, y: 1.2)

        //self.view.addSubview(popupView)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [],  animations: {
            //use if you want to darken the background
          //self.viewDim.alpha = 0.8
          //go back to original form
          self.profilePopUp.transform = .identity
        })
        self.uid = self.profilesArray[indexPath.item].uid
    }
    
    // Table View Protocol for Conversations
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversationsInfoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "conversationCell", for: indexPath as IndexPath) as! ConvoTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.convoPic.contentMode = .scaleAspectFill
        cell.convoNameLabel.text = self.conversationsInfoArray[indexPath.item].partnerProfile.name
        cell.convoPic.image = self.conversationsInfoArray[indexPath.item].partnerProfile.picture
        cell.convoMessageLabel.text = self.conversationsInfoArray[indexPath.item].latestMessageText
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let messageVC = storyboard.instantiateViewController(withIdentifier: "message") as! MessageView
        messageVC.modalPresentationStyle = .fullScreen
        messageVC.conversationPartnerProfile = self.conversationsInfoArray[indexPath.item].partnerProfile
        self.present(messageVC, animated: false, completion: nil)
    }

}
