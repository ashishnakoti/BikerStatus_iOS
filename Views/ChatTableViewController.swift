//
//  ChatTableViewController.swift
//  BikerStatus
//
//  Created by Chris T Stuart on 2/28/18.
//  Copyright © 2018 Chris T Stuart. All rights reserved.
//

import UIKit
import Firebase

class ChatTableViewController: UITableViewController {
	
	var chat = [Chat]()
	var images = [String]()
	var chatID = [String]()
	var chats = [String]()
	var index: Int!
    var recieverID: String!
	
    
    
    
	@IBOutlet weak var activePeopleCollectionView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		var count = 0;
		
		activePeopleCollectionView.delegate = self
		activePeopleCollectionView.dataSource = self
		
		self.tableView.rowHeight = 95;
		tableView.tableFooterView = UIView()
		
        firstFBcall()
		
		
	}
    
    func firstFBcall(){
        Database.database().reference(withPath: "users").child((Auth.auth().currentUser?.uid)!).child("chats").observe(.childAdded) { (snapshot) in
            var chatID = snapshot.key
            
            print(chatID)
            self.chatID.append(chatID)
            
          //  self.tableView.reloadData()
            
            
            
            var user = snapshot.value as! [String : Any]
            
            
            
            
            print("varUS", user)
            self.recieverID = user["with"] as! String
            Database.database().reference(withPath: "users").child(user["with"] as! String).observe(.value, with: { (snapthisdick) in
                
                if let userInfo = snapthisdick.value as? [String : Any] {
                    //print(userInfo)
                    print("suck",snapthisdick.key)
                    if let stfuChris = userInfo["user_full_name"] as? String, let userPicture = userInfo["user_profile_image"] as? String {
                        print("name",stfuChris)
                        print("stFU i got this",userPicture)
                        
                        self.chats.append(stfuChris)
                        self.images.append(userPicture)
                        
                        self.tableView.reloadData()
                    }
                    
                    print("dickanddie", snapthisdick.value)
                    
                    
                }
                
                
                
                
                
                //print("smd",userInfo)
                
             
                
//                            print("user info", userInfo)
//                            var userNme = ""
//                            var userPict = ""
//
//                            if snapshot.key == "full name" {
//                                userNme = snapshot.value as! String
//                                print("hit", userNme)
//                            }else if snapshot.key == "urlToImage" {
//                                userPict = snapshot.value as! String
//
//                                if (self.images.count == 0) {
//                                    self.images.append(userPict)
//                                    self.chats.append(userNme)
//                                    self.activePeopleCollectionView.reloadData()
//                                }
//
//                                var chris = self.images.contains(userPict)
//
//                                if (!chris) {
//                                    self.chats.append(userNme)
//                                    self.images.append(userPict)
//                                    self.activePeopleCollectionView.reloadData()
//                                }
//
//                            }
                
            })
            
            print(user)
            
            
        }
    }
    
//    func secondFBcall(){
//        Database.database().reference(withPath: "users").child(user["with"] as! String).observe(.childAdded, with: { (snapshot) in
//
//            let userInfo = [String : Any]()
//
//            var userNme = ""
//            var userPict = ""
//
//            if snapshot.key == "full name" {
//                userNme = snapshot.value as! String
//                print("hit", userNme)
//            }else if snapshot.key == "urlToImage" {
//                userPict = snapshot.value as! String
//
//                if (self.images.count == 0) {
//                    self.images.append(userPict)
//                    self.chats.append(userNme)
//                    self.activePeopleCollectionView.reloadData()
//                }
//
//                var chris = self.images.contains(userPict)
//
//                if (!chris) {
//                    self.chats.append(userNme)
//                    self.images.append(userPict)
//                    self.activePeopleCollectionView.reloadData()
//                }
//
//            }
//
//            )
//
//        }
//    }
//
//
//    func thirdFBcall(){
//        Database.database().reference(withPath: "chat").child(chatID).observe(.childAdded, with: { (snapshot) in
//
//            var values = snapshot.value as! [String : Any]
//
//            let text = values["text"] as! String
//            print(text)
//            let time = values["time"] as! String
//            print(time)
//
//            let userName = values["userName"] as! String
//
//            if (self.chat.count == 0) {
//                if userNme == Auth.auth().currentUser?.displayName {
//                    self.chat.append(Chat(text: text, time: time, userName: userNme, sender: "true"))
//                    self.activePeopleCollectionView.reloadData()
//                } else {
//                    self.chat.append(Chat(text: text, time: time, userName: userNme, sender: "false"))
//                    self.activePeopleCollectionView.reloadData()
//                }
//            }
//
//            if (userName == Auth.auth().currentUser?.displayName) {
//
//                if (!(self.chat.contains(where: {$0 == Chat(text: text, time: time, userName: userNme, sender: "true")}))) {
//                    self.chat.append(Chat(text: text, time: time, userName: userNme, sender: "true"))
//                    self.activePeopleCollectionView.reloadData()
//                }
//            } else {
//                if (!(self.chat.contains(where: {$0 == Chat(text: text, time: time, userName: userNme, sender: "false")}))) {
//                    self.chat.append(Chat(text: text, time: time, userName: userNme, sender: "false"))
//                    self.activePeopleCollectionView.reloadData()
//                }
//            }
//
//        })
//    }
	
	// MARK: - Table view data source
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		return self.chatID.count
	}
	
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! ChatTableViewCell
		
			cell.userName.text = chats[indexPath.row]
        	cell.userImage.downloadImage(from: images[indexPath.row])
		//		cell.lastMessage.text = chat.last?.text
		// Configure the cell...
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		index = indexPath.row
		self.performSegue(withIdentifier: "chatDetail", sender: self)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if (segue.identifier == "chatDetail") {
			
			let cell = segue.destination as! ChatDetailViewController
			cell.chatID = chatID[index]
            cell.recieverID = self.recieverID
			cell.reciverPicture = images[index]
			//cell.messages = self.chat
			
		}
	}
	
	
	
	
}

extension ChatTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chatActiveCell", for: indexPath)
		
		return cell
	}
	
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 6
	}
	
	
	
	
}
