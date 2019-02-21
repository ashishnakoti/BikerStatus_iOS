//
//  UsersViewController.swift
//  InstagramLike
//
//  Created by Vasil Nunev on 29/11/2016.
//  Copyright © 2016 Vasil Nunev. All rights reserved.
//

import UIKit
import Firebase

class UsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	
	@IBOutlet weak var tableview: UITableView!
	
	var user = [User]()
	var count = 0;
	var theFollowing = [String]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationController?.navigationBar.tintColor = .white
		retrieveUsers()
		title = "Who to follow"
	}
	
	
	func retrieveUsers() {
		let ref = Database.database().reference()
		
		ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
			
			let users = snapshot.value as! [String : AnyObject]
			print(users)
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
			self.tableview.reloadData()
		})
		ref.removeAllObservers()
		
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableview.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserCell
		
		cell.nameLabel.text = self.user[indexPath.row].fullName
		cell.userID = self.user[indexPath.row].userID
		cell.userImage.downloadImage(from: self.user[indexPath.row].imagePath!)
		
		checkFollowing(indexPath: indexPath)
		if theFollowing.count > 0 {
			for i in theFollowing {
				if i == cell.userID {
					print(indexPath.row)
					cell.accessoryType = .checkmark
				}
			}
		}
		
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return user.count ?? 0
	}
	
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let uid = Auth.auth().currentUser!.uid
		let ref = Database.database().reference()
		let key = ref.child("users").childByAutoId().key
		
		var isFollower = false
		
		ref.child("users").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
			
			if let following = snapshot.value as? [String : AnyObject] {
				for (ke, value) in following {
					print(ke)
					print(value)
					if value as! String == self.user[indexPath.row].userID {
						isFollower = true
						
						ref.child("users").child(uid).child("following/\(ke)").removeValue()
						ref.child("users").child(self.user[indexPath.row].userID).child("followers/\(ke)").removeValue()
						
						self.tableview.cellForRow(at: indexPath)?.accessoryType = .none
						
					}
				}
			}
			if !isFollower {
				let following = ["following/\(key)" : self.user[indexPath.row].userID]
				let followers = ["followers/\(key)" : uid]
				
				ref.child("users").child(uid).updateChildValues(following)
				ref.child("users").child(self.user[indexPath.row].userID).updateChildValues(followers)
				
				self.tableview.cellForRow(at: indexPath)?.accessoryType = .checkmark
				
			}
		})
		ref.removeAllObservers()
		
	}
	
	
	func checkFollowing(indexPath: IndexPath) {
		let uid = Auth.auth().currentUser!.uid
		let ref = Database.database().reference()
		
		ref.child("users").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
			
			if let following = snapshot.value as? [String : AnyObject] {
				for (_, value) in following {
					if let users = self.tableview.cellForRow(at: indexPath) as?
						UserCell {
						//						if value as! String == self.user[indexPath.row].userID && users.userID == self.user[indexPath.row].userID{
						self.theFollowing.append(value as! String)
						//self.tableview.reloadData()
						//self.tableview.cellForRow(at: indexPath)?.accessoryType = .checkmark
						//						}
					}
				}
			}
		})
		ref.removeAllObservers()
		
	}
	
	@IBAction func logOutPressed(_ sender: Any) {
		
	}
	
}









