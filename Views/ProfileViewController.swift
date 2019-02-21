//
//  ProfileViewController.swift
//  BikerStatus
//
//  Created by Chris T Stuart on 2/28/18.
//  Copyright © 2018 Chris T Stuart. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	@IBOutlet weak var userName: UILabel!
	@IBOutlet weak var userProfileImage: UIImageView!
	@IBOutlet weak var galleryTableView: UICollectionView!
	
	@IBOutlet weak var garageCollectionView: UICollectionView!
	
	let picker = UIImagePickerController()
	
	var gallery = false
	
	var galleryURL = [String]()
	var garageURL = [String]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		picker.delegate = self
		
		garageCollectionView.delegate = self
		galleryTableView.delegate = self
		
		self.userProfileImage.clipsToBounds = false
		self.userProfileImage.layer.cornerRadius = self.userProfileImage.frame.height / 2
		
		self.userName.text = Auth.auth().currentUser?.displayName
		//self.userProfileImage.image =
		
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
						self.userProfileImage.image = image
					}
				}
			}
			Database.database().reference(withPath: "users").child(uid).observe(.value, with: { (snapshot) in
				if let value = snapshot.value as? [String:Any] {
					if let gallery = value["user_gallery"] as? [String:Any] {
						//print(gallery)
						for (_, val) in gallery {
							if let data = val as? [String:Any] {
								//print(data)
								for (_, v) in data {
									print(v)
									
									if !self.galleryURL.contains(v as! String) {
										self.galleryURL.append(v as! String)
										self.galleryTableView.reloadData()
									}
								}
							}
						}
					}
					
					if let garage = value["user_garage"] as? [String:Any] {
						for (_, val) in garage {
							if let data = val as? [String:Any] {
								//print(data)
								for (_, v) in data {
									print(v)
									if !self.garageURL.contains(v as! String) {
										self.garageURL.append(v as! String)
										print(v)
										self.garageCollectionView.reloadData()
									}
								}
							}
						}
					}
				}
			})
		}
		
		
		
		
		// Do any additional setup after loading the view.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func signOutActioon(_ sender: UIBarButtonItem) {
		
		do {
			try? Auth.auth().signOut()
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let controller = storyboard.instantiateViewController(withIdentifier: "nav")
			present(controller, animated: true, completion: nil)
		}
		
	}
	
	@IBAction func addGarage(_ sender: UIButton) {
		let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
		
		let deleteAction = UIAlertAction(title: "Photo Album", style: .default, handler: {
			(alert: UIAlertAction!) -> Void in
			print("Photo Album")
			self.picker.allowsEditing = true
			self.picker.sourceType = .photoLibrary
			
			self.gallery = false
			
			self.present(self.picker, animated: true, completion: nil)
		})
		let saveAction = UIAlertAction(title: "Camera", style: .default, handler: {
			(alert: UIAlertAction!) -> Void in
			if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
				let imagePicker = UIImagePickerController()
				imagePicker.delegate = self
				imagePicker.sourceType = UIImagePickerControllerSourceType.camera
				imagePicker.allowsEditing = false
				self.present(imagePicker, animated: true, completion: nil)
			}
		})
		
		//
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
			(alert: UIAlertAction!) -> Void in
			print("Cancelled")
		})
		
		
		// 4
		optionMenu.addAction(deleteAction)
		optionMenu.addAction(saveAction)
		optionMenu.addAction(cancelAction)
		
		self.present(optionMenu, animated: true, completion: nil)
	}
	
	@IBAction func addGallery(_ sender: UIButton) {
		
		let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
		
		let deleteAction = UIAlertAction(title: "Photo Album", style: .default, handler: {
			(alert: UIAlertAction!) -> Void in
			print("Photo Album")
			self.picker.allowsEditing = true
			self.picker.sourceType = .photoLibrary
			
			self.gallery = true
			
			self.present(self.picker, animated: true, completion: nil)
		})
		let saveAction = UIAlertAction(title: "Camera", style: .default, handler: {
			(alert: UIAlertAction!) -> Void in
			if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
				let imagePicker = UIImagePickerController()
				imagePicker.delegate = self
				imagePicker.sourceType = UIImagePickerControllerSourceType.camera
				imagePicker.allowsEditing = false
				self.present(imagePicker, animated: true, completion: nil)
			}
		})
		
		//
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
			(alert: UIAlertAction!) -> Void in
			print("Cancelled")
		})
		
		
		// 4
		optionMenu.addAction(deleteAction)
		optionMenu.addAction(saveAction)
		optionMenu.addAction(cancelAction)
		
		self.present(optionMenu, animated: true, completion: nil)
		
		
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
			let uid = Auth.auth().currentUser!.uid
			let ref = Database.database().reference()
			let storage = Storage.storage().reference()
			
			if (!gallery) {
				
				let key = ref.child("garage").childByAutoId().key
				let imageRef = storage.child("garage").child(uid).child("\(key).jpg")
				
				let data = UIImageJPEGRepresentation(image, 0.6)
				
				imageRef.putData(data!, metadata: nil, completion: { (metadata, error) in
					if error != nil {
						print(error!.localizedDescription)
						self.dismiss(animated: true, completion: nil)
						return
					}
					
					imageRef.downloadURL(completion: { (url, error) in
						if error != nil {
							print(error!.localizedDescription)
							return
						}
						if let url = url {
							Database.database().reference(withPath: "users").child(uid).child("user_garage").child(UUID().uuidString).updateChildValues([UUID().uuidString: url.absoluteString])
							self.dismiss(animated: true, completion: nil)
						}
					})
					
				})
			} else {
				let key = ref.child("gallery").childByAutoId().key
				let imageRef = storage.child("gallery").child(uid).child("\(key).jpg")
				
				let data = UIImageJPEGRepresentation(image, 0.6)
				
				imageRef.putData(data!, metadata: nil, completion: { (metadata, error) in
					if error != nil {
						print(error!.localizedDescription)
						self.dismiss(animated: true, completion: nil)
						return
					}
					
					imageRef.downloadURL(completion: { (url, error) in
						if error != nil {
							print(error!.localizedDescription)
							return
						}
						if let url = url {
							Database.database().reference(withPath: "users").child(uid).child("user_gallery").child(UUID().uuidString).updateChildValues([UUID().uuidString: url.absoluteString])
							self.dismiss(animated: true, completion: nil)
						}
					})
					
				})
			}
		}
		
	}
	
	
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		if (collectionView == galleryTableView) {
			return 1
		} else {
			return 1
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if (collectionView == galleryTableView) {
			return galleryURL.count
		} else {
			return garageURL.count
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if (collectionView == galleryTableView) {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gallery", for: indexPath) as! gallery
			if galleryURL[indexPath.row] != nil {
				cell.cellImage.downloadImage(from: galleryURL[indexPath.row])
			}
			return cell
		} else {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "garage", for: indexPath) as! Gallery_GarageCollectionViewCell
			if garageURL[indexPath.row] != nil {
				cell.cellImage.downloadImage(from: garageURL[indexPath.row])
			}
			return cell
		}
	}
	
	
}
