//
//  CommentsTableViewController.swift
//  BikerStatus
//
//  Created by Chris T Stuart on 8/13/18.
//  Copyright © 2018 Chris T Stuart. All rights reserved.
//

import UIKit
import Firebase

class CommentsTableViewController: UITableViewController, UITextViewDelegate,UITextFieldDelegate  {
	
	@IBOutlet weak var newTweetTextView: UITextView!
	
	@IBOutlet weak var newTweetToolbar: UIToolbar!
	@IBOutlet weak var toolbarBottomConstraint: NSLayoutConstraint!
	var toolbarBottomConstraintInitialValue: CGFloat?
	var postID = ""
	var comments = [Comment]()
	var users = [User]()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
		
		navigationItem.rightBarButtonItems = [add]
		
		self.tableView.rowHeight = 80
		
		
		self.title = "Comments"
		
		
		let ref = Database.database().reference(withPath: "posts")
		
		ref.child(self.postID).observe(.value) { (snapshot) in
			print(snapshot.value)
			let value = snapshot.value as? [String:Any]
			print(value)
			//			if let data = value!["posts_comments"] as! [String:Any] {
			print(value)
			//
			//			for (id, data) in value! {
			//let commentData = value as! [String:Any]
			
			if let comments = value!["post_comments"] as? [String:Any] {
				
				print(comments)
				
				for (id, data) in comments {
					
					let commentData = data as! [String:Any]
					
					let comment_author_uid = commentData["comment_author_uid"] as? String
					let comment_message = commentData["comment_message"] as? String
					let comment_timestamp = commentData["comment_timestamp"] as? String
					
					print(comment_author_uid)
					print(comment_message)
					print(comment_timestamp)
					
					
					var theComment = Comment()
					theComment.userUid = comment_author_uid
					theComment.commentTimestamp = comment_timestamp
					theComment.commentMessage = comment_message
					
					
					
					Database.database().reference(withPath: "users").child(comment_author_uid!).observe(.value, with: { (userSnapshot) in
						print(userSnapshot.value)
						
						let users = User()
						
						let userD = userSnapshot.value as! [String:Any]
						users.fullName = userD["user_full_name"] as! String
						users.imagePath = userD["user_profile_image"] as! String
						
						if (!(self.comments.contains(where: {$0.commentMessage == theComment.commentMessage}))) {
						
							self.users.append(users)
							
							self.comments.append(theComment)
							self.tableView.reloadData()
							
							
						}
						
				
						
						
						
					})
					
				}
			}
				
			}

}

@objc func addTapped() {
	let alert = UIAlertController(title: "Comment", message: "Written by: " + (Auth.auth().currentUser?.displayName)!, preferredStyle: .alert)
	
	//2. Add the text field. You can configure it however you need.
	alert.addTextField { (textField) in
		textField.placeholder = "Write comment here.."
		
	}
	
	// 3. Grab the value from the text field, and print it when the user clicks OK.
	alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
		let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
		print("Text field: \(textField?.text)")
		print(self.postID)
		if (textField?.text != nil) {
			
			let dataUser = [
				"comment_author_uid" : Auth.auth().currentUser?.uid ?? "error",
				"comment_message" 	 : textField?.text ?? "error",
				"comment_timestamp"	 : Date().description
				] as [String : Any]
			
			Database.database().reference(withPath: "posts").child(self.postID).observeSingleEvent(of: .value, with: { (snapshot) in
				let data = snapshot.value as! [String : Any]
				if let likes = data["post_comments_count"] as? Int {
					print(data["post_comments_count"])
					let update = ["post_comments_count" : likes + 1]
					Database.database().reference(withPath:"posts").child(self.postID).updateChildValues(update)
					Database.database().reference(withPath: "posts").child(self.postID).child("post_comments").child(UUID().uuidString).updateChildValues(dataUser)
				}
			})
			
		}
	}))
	
	// 4. Present the alert.
	self.present(alert, animated: true, completion: nil)
}

override func viewDidAppear(_ animated: Bool) {
	enableKeyboardHideOnTap()
	
	//self.toolbarBottomConstraintInitialValue = toolbarBottomConstraint.constant
}

private func enableKeyboardHideOnTap(){
	
	NotificationCenter.default.addObserver(self, selector: #selector(CommentsTableViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
	
	NotificationCenter.default.addObserver(self, selector: #selector(CommentsTableViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
	
	let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CommentsTableViewController.hideKeyboard))
	
	self.view.addGestureRecognizer(tap)
	
}

@objc func keyboardWillShow(notification: NSNotification)
{
	let info = notification.userInfo!
	
	let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
	
	let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
	
	UIView.animate(withDuration: duration) {
		
		//self.toolbarBottomConstraint.constant = keyboardFrame.size.height
		
		//self.newTweetToolbar.isHidden = false
		self.view.layoutIfNeeded()
	}
}

@objc func keyboardWillHide(notification: NSNotification)
{
	let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
	
	UIView.animate(withDuration: duration) {
		
		//	self.toolbarBottomConstraint.constant = self.toolbarBottomConstraintInitialValue!
		
		//self.newTweetToolbar.isHidden = true
		self.view.layoutIfNeeded()
	}
}

@objc func hideKeyboard(){
	self.view.endEditing(true)
}


override func didReceiveMemoryWarning() {
	super.didReceiveMemoryWarning()
	// Dispose of any resources that can be recreated.
}

@IBAction func didTapCancel(sender: AnyObject) {
	
	dismiss(animated: true
		, completion: nil)
}

func textViewDidBeginEditing(_ textView: UITextView) {
	
	if(newTweetTextView.textColor == UIColor.lightGray)
	{
		newTweetTextView.text = ""
		newTweetTextView.textColor = UIColor.black
	}
}

func textFieldShouldReturn(_ textField: UITextField) -> Bool {
	
	textField.resignFirstResponder()
	return false
}


// MARK: - Table view data source

override func numberOfSections(in tableView: UITableView) -> Int {
	// #warning Incomplete implementation, return the number of sections
	return 1
}

override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
	// #warning Incomplete implementation, return the number of rows
	return self.comments.count
}


override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
	let cell = tableView.dequeueReusableCell(withIdentifier: "comments", for: indexPath) as! CommentsTableViewCell
	
	cell.cDescription.text = self.comments[indexPath.row].commentMessage
	if self.users.count > 0 {
		cell.username.text = self.users[indexPath.row].fullName
		cell.profile_image.downloadImage(from: self.users[indexPath.row].imagePath)
	}
	
	// Configure the cell...
	
	return cell
}


/*
// Override to support conditional editing of the table view.
override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
// Return false if you do not want the specified item to be editable.
return true
}
*/

/*
// Override to support editing the table view.
override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
if editingStyle == .delete {
// Delete the row from the data source
tableView.deleteRows(at: [indexPath], with: .fade)
} else if editingStyle == .insert {
// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
}
}
*/

/*
// Override to support rearranging the table view.
override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

}
*/

/*
// Override to support conditional rearranging of the table view.
override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
// Return false if you do not want the item to be re-orderable.
return true
}
*/

/*
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
// Get the new view controller using segue.destinationViewController.
// Pass the selected object to the new view controller.
}
*/

}
