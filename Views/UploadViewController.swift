//
//  UploadViewController.swift
//  InstagramLike
//
//  Created by Vasil Nunev on 11/12/2016.
//  Copyright © 2016 Vasil Nunev. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
	
	
	@IBOutlet weak var previewImage: UIImageView!
	@IBOutlet weak var postBtn: UIButton!
	@IBOutlet weak var selectBtn: UIButton!
	@IBOutlet weak var uploudDesc: UITextView!
	
	@IBOutlet weak var backView: UIView!
	
	@IBOutlet weak var userName: UILabel!
	@IBOutlet weak var userProfilePicture: UIImageView!
	
	var picker = UIImagePickerController()
	var uploaded = false
	var activity: NVActivityIndicatorView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "Add Post"
		
		activity = NVActivityIndicatorView(frame: self.view.frame, type: .circleStrokeSpin, color: .black, padding: 100)
		self.view.addSubview(activity)
		
		
		picker.delegate = self
		uploudDesc.delegate = self
		
		self.uploudDesc.scrollRangeToVisible(NSMakeRange(0, 0))
		
		self.userProfilePicture.clipsToBounds = true
		
		
		
		
		if let uid = Auth.auth().currentUser?.uid {
			let profileImage = Storage.storage().reference(withPath: "users").child(uid + ".jpg")
			profileImage.getData(maxSize: 1 * 1024 * 1024) { data, error in
				if let error = error {
					// Uh-oh, an error occurred!
					print(error)
				} else {
					// Data for "images/island.jpg" is returned
					let image = UIImage(data: data!)
					DispatchQueue.main.async {
						self.userProfilePicture.image = image
						self.userName.text = Auth.auth().currentUser?.displayName
					}
				}
			}
		}
		
	}
	
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
			self.previewImage.image = image
			selectBtn.isHidden = true
			postBtn.isHidden = false
			uploaded = true
		}
		
		self.dismiss(animated: true, completion: nil)
	}
	
	
	@IBAction func selectPressed(_ sender: Any) {
		
//        picker.allowsEditing = true
//        picker.sourceType = .photoLibrary
//
//
//        self.present(picker, animated: true, completion: nil)
    
        let alert = UIAlertController(title: "Choose option", message: nil, preferredStyle: .actionSheet)
		
		alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: { _ in
			self.openGallary()
		}))
		
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
		
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        /*If you want work actionsheet on ipad
         then you have to use popoverPresentationController to present the actionsheet,
         otherwise app will crash on iPad */
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender as? UIView
            alert.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
		
	}
	
	
	@IBAction func postPressed(_ sender: Any) {
		
		
		
		
		if (uploaded) {
			
			self.activity.startAnimating()
			self.view.isUserInteractionEnabled = false
			
			let uid = Auth.auth().currentUser!.uid
			let ref = Database.database().reference()
			let storage = Storage.storage().reference()
			
			let key = ref.child("posts").childByAutoId().key
			let imageRef = storage.child("posts").child(uid).child("\(key).jpg")
			
			let data = UIImageJPEGRepresentation(self.previewImage.image!, 0.6)
			
			let uploadTask = imageRef.putData(data!, metadata: nil) { (metadata, error) in
				if error != nil {
					print(error!.localizedDescription)
					self.activity.stopAnimating()
					self.view.isUserInteractionEnabled = true
					return
				}
				
				imageRef.downloadURL(completion: { (url, error) in
					if let url = url {
						let feed = ["user_id" : uid,
									"post_path_to_image" : url.absoluteString,
									"post_likes_count" : 0,
									"post_comments_count": 0,
									"post_author" : Auth.auth().currentUser!.displayName!,
									"post_description" : self.uploudDesc.text,
									"post_report_count" : 0,
									"post_id" : key] as [String : Any]
						
						
						let postFeed = ["\(key)" : feed]
						
						ref.child("posts").updateChildValues(postFeed)
						self.activity.stopAnimating()
						
						self.navigationController?.popViewController(animated: true)
					}
				})
				
			}
			
			uploadTask.resume()
			
		} else if(self.uploudDesc.text == "Write your description here..." || self.uploudDesc.text == "") {
			self.activity.stopAnimating()
			self.view.isUserInteractionEnabled = true
			let al = UIAlertController(title: "Message", message: "You have to write a description.", preferredStyle: .actionSheet)
			
			let arlet = UIAlertAction(title: "Ok", style: .default, handler: nil)
			al.addAction(arlet)
			present(al, animated: true, completion: nil)
		} else {
			self.activity.stopAnimating()
			self.view.isUserInteractionEnabled = true
			let al = UIAlertController(title: "Picture", message: "You have to submit a picture.", preferredStyle: .actionSheet)
			
			let arlet = UIAlertAction(title: "Ok", style: .default, handler: nil)
			al.addAction(arlet)
			present(al, animated: true, completion: nil)
		}
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		uploudDesc.setContentOffset(CGPoint.zero, animated: false)
	}
	
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		if text == "\n" {
			textView.resignFirstResponder()
			return false
		}
		return true
	}
	
	func textViewDidBeginEditing(_ textView: UITextView) {
		uploudDesc.text = ""
	}
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
    }
	
	
}
