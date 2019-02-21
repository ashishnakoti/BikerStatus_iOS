//
//  PostCell.swift
//  InstagramLike
//
//  Created by Vasil Nunev on 13/12/2016.
//  Copyright © 2016 Vasil Nunev. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {
    
	@IBOutlet weak var commentButton: UIButton!
	@IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
	@IBOutlet weak var userImage: UIImageView!
	@IBOutlet weak var postDescription: UITextView!
	
	@IBOutlet weak var blockUser: UIButton!
	
	@IBOutlet weak var flagPost: UIButton!
	
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var unlikeBtn: UIButton!
    
	@IBOutlet weak var backView: UIView!
	var postID: String!
	
	override func awakeFromNib() {
		
		self.userImage.layer.cornerRadius = self.userImage.frame.width / 2
		
		self.backView.layer.cornerRadius = 5
		self.backView.layer.cornerRadius = 5
	
		//self.backView.layer.masksToBounds = false
		self.backView.layer.shadowColor = UIColor.black.cgColor
		self.backView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
		self.backView.layer.shadowOpacity = 0.3
		self.backView.layer.shadowRadius = CGFloat(1.0)
		commentButton.tag = 0
	}
    
    
    @IBAction func likePressed(_ sender: Any) {
        self.likeBtn.isEnabled = false
        let ref = Database.database().reference()
        let keyToPost = ref.child("posts").childByAutoId().key
		
		
		print(self.postID)
		
        ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: { (snapshot) in

			if (snapshot.value as? [String : AnyObject]) != nil {
//				let updateLikes: [String : Any] = ["peopleWhoLike/\(keyToPost)" : Auth.auth().currentUser!.uid]
//                ref.child("posts").child(self.postID).updateChildValues(updateLikes, withCompletionBlock: { (error, reff) in

				
				
//                    if error == nil {

                            if let properties = snapshot.value as? [String : AnyObject] {
								print(properties["post_likes_count"])
                                if let likes = properties["post_likes_count"] as? Int {
                                    let count = likes
                                    //self.likeLabel.text = "\(count) Likes"

                                    let update = ["post_likes_count" : count + 1]
                                    ref.child("posts").child(self.postID).updateChildValues(update)

                                    self.likeBtn.isHidden = true
                                    self.unlikeBtn.isHidden = false
                                    self.unlikeBtn.isEnabled = true
                                }
                            }

//                    }
//                })
            }


        })
		
        ref.removeAllObservers()
    }
    
    
    @IBAction func unlikePressed(_ sender: Any) {
        self.unlikeBtn.isEnabled = false
        let ref = Database.database().reference()
        
        
		print(self.postID)
		
		ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: { (snapshot) in
			
			if (snapshot.value as? [String : AnyObject]) != nil {

				if let properties = snapshot.value as? [String : AnyObject] {
					print(properties["post_likes_count"])
					if let likes = properties["post_likes_count"] as? Int {
						let count = likes

						if (count > 0) {
						
						let update = ["post_likes_count" : count - 1]
						ref.child("posts").child(self.postID).updateChildValues(update)
							
						}
						
						self.likeBtn.isHidden = false
						self.unlikeBtn.isHidden = true
						self.likeBtn.isEnabled = true
					}
				}
			}
			
		})
		
		ref.removeAllObservers()
	}
}
