//
//  FeedViewController.swift
//  InstagramLike
//
//  Created by Vasil Nunev on 13/12/2016.
//  Copyright © 2016 Vasil Nunev. All rights reserved.
//

import UIKit
import Firebase
import MessageUI
import NVActivityIndicatorView

class FeedViewController: UITableViewController, MFMailComposeViewControllerDelegate {
	
	
	@IBOutlet weak var collectionview: UITableView!
	
	
	
	var posts = [Post]()
	var following = [String]()
	var followingImages = [String]()
	var blocked = [String]()
	var activity: NVActivityIndicatorView!
	var index = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		activity = NVActivityIndicatorView(frame: self.view.frame, type: .circleStrokeSpin, color: .black, padding: 100)
		self.view.addSubview(activity)
		
		collectionview.rowHeight = 550;
		
		if (UserDefaults.standard.bool(forKey: "done") ==  false || UserDefaults.standard.bool(forKey: "done") == nil) {
			
//			if let email = Auth.auth().currentUser?.email{
//				sendEmail(userEmail: email)
//				UserDefaults.standard.set(true, forKey: "done")
//			}
			
			
		}
		
		
		
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		print(posts.count)
		self.posts.removeAll()
		self.following.removeAll()
		self.blocked.removeAll()
		self.followingImages.removeAll()
		self.tableView.reloadData()
		//activity.startAnimating()
		fetchPosts()
	}
	
	func sendEmail(userEmail: String) {
		if MFMailComposeViewController.canSendMail() {
			let mail = MFMailComposeViewController()
			mail.mailComposeDelegate = self as! MFMailComposeViewControllerDelegate
			mail.setToRecipients([userEmail])
			mail.title = "Digital coupons from Biker Status"
			
			mail.setMessageBody("-WELCOME TO BIKER STATUS NATION-\n" +
				"\n" +
				"Thank you for joining us on what is sure to be the most amazing ride of your life!\n" +
				"\n" +
				"Show your profile picture to participating retailers in order to receive all of our awesome discounts. \n" +
				"\n" +
				"\n" +
				"Biker Status, a 1st-of-its-kind social media platform specifically designed for the motorcycle industry.\n" +
				"\n" +
				"\n" +
				"We're doing that by incorporating some truly incredible features into the platform, such as:\n" +
				"-  Interactive rally maps\n" +
				"- Event calendars (both local and throughout the country)\n" +
				"- Full GPS functionality\n" +
				"- Gamified rider profiles\n" +
				"- A newsfeed focused on things bikers care about, free from the click-bait and false facts that flood traditional social media outlets\n" +
				"\n" +
				"And quite a bit more ...\n" +
				" \n" +
				"We're launching our Beta during this year's 2018 Daytona Bike Week, and want to invite you to be a part of it. \n" +
				"\n" +
				"Please send us any feedback on our application so that we can make sure to meet everyone's motorcycle needs  \n" +
				"\n" +
				"\n" +
				"Participating retailer deals \n" +
				"\n" +
				"Affliction- 30% off merchandise\n" +
				"Biker clothing company- 10% off \n" +
				"Hellcovers- 20% off \n" +
				"Asylum tattoos- 10% off tattoos over $500 and $10 off any under that\n" +
				"Sunsetters- 2 for 1 drinks\n" +
				"Sickboy- 10% off\n" +
				"One sexy biker chick- 10% off\n" +
				"Hellanbach- $6 rally shirt w/ purchase of hellanbach clothing \n" +
				"Chrome premium cigars- 10% off everything.\n" +
				"Boot hill saloon north- free parking on US1\n" +
				"Strip club choppers- free poster giveaways ", isHTML: false)
			present(mail, animated: true)
		} else {
			// show failure alert
		}
	}
	
	
	
	func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
		UserDefaults.standard.set(true, forKey: "done")
		controller.dismiss(animated: true)
	}
	
	@IBAction func FlagPost(_ sender: UIButton) {
		
		let alert = UIAlertController(title: "Flag", message: "Are you sure you want to flag this post?", preferredStyle: .alert)
		
		let ok = UIAlertAction(title: "Flag", style: .destructive) { (action) in
			print(self.posts[sender.tag].postID)
			
			Database.database().reference(withPath: "posts").child(self.posts[sender.tag].postID).child("flags").updateChildValues([UUID().uuidString:"flag"])
			
			let al = UIAlertController(title: "Flag", message: "You have flagged this post. It will remove it from your feed.", preferredStyle: .actionSheet)
			
			self.posts.remove(at: sender.tag)
			
			let arlet = UIAlertAction(title: "Done", style: .default, handler: nil)
			al.addAction(arlet)
			self.present(al, animated: true, completion: nil)
			
		}
		
		let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
			
		}
		
		alert.addAction(ok)
		alert.addAction(cancel)
		
		present(alert, animated: true, completion: nil)
		
		
	}
	
	@IBAction func BlockUser(_ sender: UIButton) {
		print(sender.tag)
		
		let alert = UIAlertController(title: "Block", message: "Are you sure you want to block user?", preferredStyle: .alert)
		
		let ok = UIAlertAction(title: "Block", style: .destructive) { (action) in
			Database.database().reference(withPath: "users").child((Auth.auth().currentUser?.uid)!).child("bloked").updateChildValues([UUID().uuidString: self.posts[sender.tag].userID])
			
			
			
			let indexes = self.posts.enumerated().filter { $0.element.userID == self.posts[sender.tag].userID }.map{ $0.offset }
			for index in indexes.reversed() {
				self.posts.remove(at: index)
				self.tableView.reloadData()
			}
			
			let al = UIAlertController(title: "Blocked", message: "You have blocked this user. We will remove every posts from the feed", preferredStyle: .actionSheet)
			
			let arlet = UIAlertAction(title: "Done", style: .default, handler: nil)
			al.addAction(arlet)
			self.present(al, animated: true, completion: nil)
		}
		
		let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
			
		}
		
		alert.addAction(ok)
		alert.addAction(cancel)
		
		present(alert, animated: true, completion: nil)
		
		
		
	}
	
	func fetchPosts(){
		
		let ref = Database.database().reference()
		
		ref.child("users").observeSingleEvent(of: .value, with: { snapshot in
			
			if let users = snapshot.value as? [String : AnyObject] {
				
				print(users)
				
				for (_,value) in users {
					
					if let urlToImage = value["user_profile_image"] as? String {
						
						print(urlToImage)
						print(value)
						
						
						if let uid = value["user_uid"] as? String {
							print(uid)
							print(Auth.auth().currentUser?.uid)
							
							if (uid == Auth.auth().currentUser?.uid) {
								print("workes right")
								print(urlToImage)
							}
							
							if uid == Auth.auth().currentUser?.uid {
								print("workes")
								if let bloked = value["user_blocked"] as? [String:Any] {
									for (keys, blocked) in bloked {
										print(blocked)
										self.blocked.append(blocked as! String)
										self.activity.stopAnimating()
									}
									
									if let followingUsers = value["following"] as? [String : String]{
										for (_,user) in followingUsers{
										
												self.following.append(user)
												self.activity.stopAnimating()
												
										
										}
									}
								} else {
									
									if let followingUsers = value["following"] as? [String : String]{
										for (_,user) in followingUsers{
											
												self.following.append(user)
												self.activity.stopAnimating()
												
											
										}
									}
								}
								
								self.following.append(Auth.auth().currentUser!.uid)
								
								ref.child("posts").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snap) in
									
									
									if let postsSnap = snap.value as? [String : AnyObject] {
										
										for (_,post) in postsSnap {
											if let userID = post["user_id"] as? String {
												for each in self.following  {
													
													if (self.blocked.count > 0) {
														
														for block in self.blocked {
															
															if !(userID == block) {
																
																if each == userID {
																	let posst = Post()
																	if let author = post["post_author"] as? String, let likes = post["post_likes_count"] as? Int, let pathToImage = post["post_path_to_image"] as? String, let postID = post["post_id"] as? String, let desc = post["post_description"] as? String {
																		
																		
																		
																		posst.postDescription = desc
																		posst.author = author
																		posst.likes = likes
																		posst.pathToImage = pathToImage
																		posst.postID = postID
																		posst.userID = userID
																		posst.userImage = urlToImage
																		if let people = post["peopleWhoLike"] as? [String : AnyObject] {
																			for (_,person) in people {
																				posst.peopleWhoLike.append(person as! String)
																			}
																		}
																		DispatchQueue.main.async {
																			
																			if (self.posts.count == 0) {
																				self.posts.append(posst)
																				self.activity.stopAnimating()
																				self.tableView.reloadData()
																			}
																			
																			if (!(self.posts.contains(where: {$0.postID == posst.postID}))) {
																				self.activity.stopAnimating()
																				self.posts.append(posst)
																				self.tableView.reloadData()
																			}
																		}
																	}
																}
																
															} else {
																let indexes = self.posts.enumerated().filter { $0.element.userID == block }.map{ $0.offset }
																for index in indexes.reversed() {
																	self.posts.remove(at: index)
																	self.tableView.reloadData()
																	self.activity.stopAnimating()
																}
															}
														}
													} else {
														if each == userID {
															let posst = Post()
															if let author = post["post_author"] as? String, let likes = post["post_likes_count"] as? Int, let pathToImage = post["post_path_to_image"] as? String, let postID = post["post_id"] as? String, let desc = post["post_description"] as? String {
																
																
																
																posst.postDescription = desc
																posst.author = author
																posst.likes = likes
																posst.pathToImage = pathToImage
																posst.postID = postID
																posst.userID = userID
																posst.userImage = pathToImage
																if let people = post["peopleWhoLike"] as? [String : AnyObject] {
																	for (_,person) in people {
																		posst.peopleWhoLike.append(person as! String)
																	}
																}
																
																	
																	if (!(self.posts.contains(where: {$0.postID == posst.postID}))) {
																		self.activity.stopAnimating()
																		self.posts.append(posst)
																		self.tableView.reloadData()
																		
																	
																}
															}
														}
													}
												}
											}
										}
									}
								})
							} else {
								//print(users)
							}
						}
					}
				}
			} else {
				self.activity.stopAnimating()
			}
		})
		
		
		//ref.removeAllObservers()
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.posts.count
	}
	
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostCell
		
		cell.blockUser.tag = indexPath.row
		cell.flagPost.tag = indexPath.row
		
		print(self.posts[indexPath.row].pathToImage)
		
		cell.commentButton.tag = indexPath.row
		
		cell.postImage.downloadImage(from: self.posts[indexPath.row].pathToImage)
		cell.authorLabel.text = self.posts[indexPath.row].author
		cell.postDescription.text = self.posts[indexPath.row].postDescription
		cell.userImage.downloadImage(from: self.posts[indexPath.row].userImage)
		//cell.likeLabel.text = "\(self.posts[indexPath.row].likes!) Likes"
		cell.postID = self.posts[indexPath.row].postID
		
		
		
		for person in self.posts[indexPath.row].peopleWhoLike {
			if person == Auth.auth().currentUser!.uid {
				//cell.likeBtn.isHidden = true
				//cell.unlikeBtn.isHidden = false
				break
			}
		}
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print(indexPath.row)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if(segue.identifier == "comments") {
			let segue = segue.destination as! CommentsTableViewController
			let commentButton = sender as! UIButton
			print(commentButton.tag)
			segue.postID = self.posts[commentButton.tag].postID
		}
		
	}
	
	
}


extension UIImageView {
	
	func downloadImage(from imgURL: String!) {
		let url = URLRequest(url: URL(string: imgURL)!)
		
		let task = URLSession.shared.dataTask(with: url) {
			(data, response, error) in
			
			if error != nil {
				print(error!)
				return
			}
			
			DispatchQueue.main.async {
				self.image = UIImage(data: data!)
			}
			
		}
		
		task.resume()
	}
}
