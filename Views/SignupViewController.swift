//
//  SignUpViewController.swift
//  BikerStatus
//
//  Created by Chris T Stuart on 2/24/18.
//  Copyright © 2018 Chris T Stuart. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Firebase

class SignupViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate  {
	
	
	@IBOutlet weak var nameField: UITextField!
	@IBOutlet weak var emailField: UITextField!
	@IBOutlet weak var password: UITextField!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var nextBtn: UIButton!
	@IBOutlet weak var backView: UIView!
	
	let picker = UIImagePickerController()
	var userStorage: StorageReference!
	var ref: DatabaseReference!
	var activity: NVActivityIndicatorView!
	
	var didPick = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = "Register"
		
		let frame = CGRect(x: self.view.frame.width / 2, y: self.view.frame.height / 2, width: 50, height: 50)
		
		activity = NVActivityIndicatorView(frame: self.view.frame, type: .circleStrokeSpin, color: .black, padding: 100)
		self.view.addSubview(activity)
		
		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
		self.navigationController?.navigationBar.shadowImage = UIImage()
		self.navigationController?.navigationBar.isTranslucent = true
		self.navigationController?.view.backgroundColor = UIColor.clear
		
		self.imageView.layer.cornerRadius = 5
		self.backView.layer.cornerRadius = 5
		self.nextBtn.layer.cornerRadius = 5
		//self.backView.layer.masksToBounds = false
		self.backView.layer.shadowColor = UIColor.black.cgColor
		self.backView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
		self.backView.layer.shadowOpacity = 0.3
		self.backView.layer.shadowRadius = CGFloat(1.0)
		
		nameField.delegate = self
		emailField.delegate = self
		password.delegate = self
		
		picker.delegate = self
		
		let storage = Storage.storage();
		
		ref = Database.database().reference()
		userStorage = storage.reference().child("users")
		
	}
	
	
	@IBAction func selectImagePressed(_ sender: Any) {
		
		picker.allowsEditing = true
		picker.sourceType = .photoLibrary
		
		present(picker, animated: true, completion: nil)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
			self.imageView.image = image
			nextBtn.isHidden = false
			didPick = true
		}
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func nextPressed(_ sender: Any) {
		
		guard nameField.text != "", emailField.text != "", password.text != "" else { return}
		
		if didPick {
			
			activity.startAnimating()
			self.view.isUserInteractionEnabled = false
			
			Auth.auth().createUser(withEmail: emailField.text!, password: password.text!, completion: { (user, error) in
				
				
				if let error = error {
					print(error.localizedDescription)
					self.activity.stopAnimating()
					self.view.isUserInteractionEnabled = true
				}
				
				if let user = user {
					
					let changeRequest = Auth.auth().currentUser!.createProfileChangeRequest()
					changeRequest.displayName = self.nameField.text!
					changeRequest.commitChanges(completion: nil)
					
					let imageRef = self.userStorage.child("\(user.uid).jpg")
					
					if let data = UIImageJPEGRepresentation(self.imageView.image!, 0.5) {
						
						
						let uploadTask = imageRef.putData(data, metadata: nil, completion: { (metadata, err) in
							if err != nil {
								print(err!.localizedDescription)
							}
							
							imageRef.downloadURL(completion: { (url, er) in
								if er != nil {
									print(er!.localizedDescription)
								}
								
								
								if let url = url {
									
									let userInfo: [String : Any] = ["user_uid" : user.uid,
																	"user_full_name" : self.nameField.text!,
																	"user_profile_image" : url.absoluteString]
									
									self.ref.child("users").child(user.uid).setValue(userInfo)
									
									
									
									self.activity.stopAnimating()
									self.view.isUserInteractionEnabled = false
									let storyboard = UIStoryboard(name: "Main", bundle: nil)
									let controller = storyboard.instantiateViewController(withIdentifier: "main")
									self.present(controller, animated: true, completion: nil)
									
                                }
							})
						})
						uploadTask.resume()
					}
				}
				
				
			})
			
		} else {
			activity.stopAnimating()
			self.view.isUserInteractionEnabled = true
			let alert = UIAlertController(title: "Failed", message: "Pleased provided a image to create your profile.", preferredStyle: .actionSheet)
			let alertButton = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
			alert.addAction(alertButton)
			self.present(alert, animated: true, completion: nil)
			
		}
		
	}
	
	//	func sendEmail(userEmail: String) {
	//		if MFMailComposeViewController.canSendMail() {
	//			let mail = MFMailComposeViewController()
	//			mail.mailComposeDelegate = self as! MFMailComposeViewControllerDelegate
	//			mail.setToRecipients([userEmail])
	//
	//			mail.setMessageBody("-WELCOME TO BIKER STATUS NATION-\n" +
	//				"\n" +
	//				"Thank you for joining us on what is sure to be the most amazing ride of your life!\n" +
	//				"\n" +
	//				"Show your profile picture to participating retailers in order to receive all of our awesome discounts. \n" +
	//				"\n" +
	//				"\n" +
	//				"Biker Status, a 1st-of-its-kind social media platform specifically designed for the motorcycle industry.\n" +
	//				"\n" +
	//				"\n" +
	//				"We're doing that by incorporating some truly incredible features into the platform, such as:\n" +
	//				"-  Interactive rally maps\n" +
	//				"- Event calendars (both local and throughout the country)\n" +
	//				"- Full GPS functionality\n" +
	//				"- Gamified rider profiles\n" +
	//				"- A newsfeed focused on things bikers care about, free from the click-bait and false facts that flood traditional social media outlets\n" +
	//				"\n" +
	//				"And quite a bit more ...\n" +
	//				" \n" +
	//				"We're launching our Beta during this year's 2018 Daytona Bike Week, and want to invite you to be a part of it. \n" +
	//				"\n" +
	//				"Please send us any feedback on our application so that we can make sure to meet everyone's motorcycle needs  \n" +
	//				"\n" +
	//				"\n" +
	//				"Participating retailer deals \n" +
	//				"\n" +
	//				"Affliction- 30% off merchandise\n" +
	//				"Biker clothing company- 10% off \n" +
	//				"Hellcovers- 20% off \n" +
	//				"Asylum tattoos- 10% off tattoos over $500 and $10 off any under that\n" +
	//				"Sunsetters- 2 for 1 drinks\n" +
	//				"Sickboy- 10% off\n" +
	//				"One sexy biker chick- 10% off\n" +
	//				"Hellanbach- $6 rally shirt w/ purchase of hellanbach clothing \n" +
	//				"Chrome premium cigars- 10% off everything.\n" +
	//				"Boot hill saloon north- free parking on US1\n" +
	//				"Strip club choppers- free poster giveaways ", isHTML: false)
	//			mail.delegate = self
	//			present(mail, animated: true)
	//		} else {
	//			// show failure alert
	//		}
	//	}
	
	
	
	
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField == nameField {
			nameField.resignFirstResponder()
			emailField.becomeFirstResponder()
		} else if textField == emailField {
			emailField.resignFirstResponder()
			password.becomeFirstResponder()
		} else if textField == password {
			password.resignFirstResponder()
		}
		return true
	}
	
}
