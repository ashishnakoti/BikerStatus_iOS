//
//  createChatTableViewController.swift
//  BikerStatus
//
//  Created by Chris T Stuart on 3/7/18.
//  Copyright © 2018 Chris T Stuart. All rights reserved.
//

import UIKit
import Firebase

class createChatTableViewController: UITableViewController {

	@IBOutlet var profileImage: UIImageView!
	@IBOutlet var profileName: UILabel!
	
	var user = [User]()
	var isFollower = false
	var theUser: User!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		self.title = "Who you want to chat with"
		self.navigationController?.navigationBar.tintColor = .white

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
		
		self.tableView.rowHeight = 77
		
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create chat", style: .plain, target: self, action: #selector(create))
		
		self.navigationItem.rightBarButtonItem?.isEnabled = false
		
		retrieveUsers()
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	func retrieveUsers() {
		let ref = Database.database().reference()
		
		ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
			
			let users = snapshot.value as! [String : AnyObject]
			self.user.removeAll()
			for (_, value) in users {
				if let uid = value["user_id"] as? String {
					if uid != Auth.auth().currentUser!.uid {
						let userToShow = User()
						if let fullName = value["user_full_name"] as? String, let imagePath = value["user_profile_image"] as? String {
							userToShow.fullName = fullName
							userToShow.imagePath = imagePath
							userToShow.userID = uid
							self.user.append(userToShow)
						}
					}
				}
			}
			self.tableView.reloadData()
		})
		ref.removeAllObservers()
		
	}
	
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.user.count
    }

	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addChatCell", for: indexPath) as! UserCell

		cell.nameLabel.text = self.user[indexPath.row].fullName
		cell.userImage.downloadImage(from: self.user[indexPath.row].imagePath)
        // Configure the cell...

        return cell
    }
	
	@objc func create() {
		print("Chris")
        let chatID = UUID().uuidString
        Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("chats").child(chatID).updateChildValues(["with":theUser.userID])
        
		Database.database().reference().child("users").child(theUser.userID).child("chats").child(chatID).updateChildValues(["with":Auth.auth().currentUser?.uid ?? "error"])

		Database.database().reference().child("chats").child(chatID).child(UUID().uuidString).updateChildValues(["user_name": Auth.auth().currentUser?.displayName ?? "error", "time_chat_received" : "", "chat_text" : "Hi, " + theUser.fullName])
        
		self.navigationController?.popViewController(animated: true)
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		if (!isFollower) {
			self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
			theUser = self.user[indexPath.row]
			self.navigationItem.rightBarButtonItem?.isEnabled = true
			isFollower = true
		} else {
			self.navigationItem.rightBarButtonItem?.isEnabled = false
			self.tableView.cellForRow(at: indexPath)?.accessoryType = .none
			isFollower = false
		}
		
	}

}
