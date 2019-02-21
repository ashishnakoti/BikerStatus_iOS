//
//  MapViewController.swift
//  BikerStatus
//
//  Created by Chris T Stuart on 2/28/18.
//  Copyright © 2018 Chris T Stuart. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase

class MapViewController: UIViewController, GMSMapViewDelegate {
	
	@IBOutlet weak var map: GMSMapView!
	@IBOutlet var directionTo: UITextField!
	
	private let locationManager = CLLocationManager()
	var user = [User]()
	var locatiBS: CLLocation!
	var goingToPosition: CLLocationCoordinate2D!
	var markes: [GMSMarker] = [GMSMarker]()
	
	@IBOutlet weak var backView: UIView!
	
	@IBOutlet weak var hideButton: UIBarButtonItem!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		map.delegate = self
		self.navigationController?.navigationBar.tintColor = .white
		
		self.backView.layer.cornerRadius = 5
		
		//self.backView.layer.masksToBounds = false
		self.backView.layer.shadowColor = UIColor.black.cgColor
		self.backView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
		self.backView.layer.shadowOpacity = 0.3
		self.backView.layer.shadowRadius = CGFloat(1.0)
		
		locationManager.delegate = self
		locationManager.requestAlwaysAuthorization()
		locationManager.startUpdatingLocation()
		
		map.isMyLocationEnabled = true
		
		
		retrieveUsers()
		
		// Do any additional setup after loading the view.
	}
	
	func retrieveUsers() {
		let ref = Database.database().reference()
		
		ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
			
			let users = snapshot.value as! [String : AnyObject]
			self.user.removeAll()
			for (_, value) in users {
				if let uid = value["uid"] as? String {
					if uid != Auth.auth().currentUser!.uid {
						let userToShow = User()
						if let fullName = value["full name"] as? String, let imagePath = value["urlToImage"] as? String, let on = value["locationON"] as? Bool, let location = value["location"] as? [String:Any] {
							userToShow.fullName = fullName
							userToShow.imagePath = imagePath
							userToShow.userID = uid
							if (on) {
								print(location["lat"] as! Double)
								print(location["lon"] as! Double)
								
								let imagefo = self.downloadImage(url: URL(string: imagePath)!)
								
								//creating a marker view
								let markerView = UIImageView(image: imagefo)
								
								let position = CLLocationCoordinate2D(latitude: location["lat"] as! Double, longitude: location["lon"] as! Double)
								let marker = GMSMarker(position: position)
								//marker.iconView = markerView
								self.markes.append(marker)
								self.markes.first?.title = fullName
								self.markes.first?.map = self.map
								
							}
							
							self.user.append(userToShow)
						}
					}
				}
			}
			
		})
		ref.removeAllObservers()
		
	}
	
	func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
		print(coordinate)
		if markes.count > 1 {
		
			goingToPosition = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
			let marker = GMSMarker(position: goingToPosition)
			directionTo.text = coordinate.latitude.description + " " + coordinate.longitude.description
			self.markes.last?.map = nil
			self.markes.removeLast()
			self.directionTo.text = ""
		} else {
			goingToPosition = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
			let marker = GMSMarker(position: goingToPosition)
			directionTo.text = coordinate.latitude.description + " " + coordinate.longitude.description
			self.markes.append(marker)
			self.markes.last?.title = "Go to here"
			self.markes.last?.map = map
		}
	}
	
	@IBAction func hideAction(_ sender: UIBarButtonItem) {
		
		var count = 0;
		
		if let uid = Auth.auth().currentUser?.uid {
			
			Database.database().reference(withPath: "users").child(uid).observe(.value, with: { (snapshot) in
				if let value = snapshot.value as? [String:Any] {
					if let locationON = value["locationON"] as? Bool {
						if count == 0 {
							if (locationON) {
								self.hideButton.title = "UNHIDE FROM YOUR FRIENDS"
								Database.database().reference(withPath: "users").child(uid).updateChildValues(["locationON": false])
								
							} else {
								self.hideButton.title = "HIDE FROM YOUR FRIENDS"
								Database.database().reference(withPath: "users").child(uid).updateChildValues(["locationON": true])
								
							}
							count += 1
						}
					}
				}
			})
		}
	}
	
	
	@IBAction func Go(_ sender: UIButton) {
		if directionTo.text != "" {
			if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!))
			{
				if locatiBS != nil {
					UIApplication.shared.open(URL(string:"comgooglemaps://?center=\(self.locatiBS.coordinate.latitude),\(self.locatiBS.coordinate.longitude)&zoom=14&views=traffic&q=\(self.goingToPosition.latitude),\(self.goingToPosition.longitude)")!, options: [:], completionHandler: nil)
				}
			} else
			{
				let alert = UIAlertController(title: "GPS", message: "You currently dont have the Google Maps app installed in your phone. To have full GPS capabilities you need to download the Google Maps app.", preferredStyle: .alert)
				let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
				alert.addAction(ok)
				present(alert, animated: true, completion: nil)
			}
		} else {
			let alert = UIAlertController(title: "GPS", message: "You need to touch the map to place a pin on where you want to go.", preferredStyle: .alert)
			let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
			alert.addAction(ok)
			present(alert, animated: true, completion: nil)
		}
	}
	
	func downloadImage(url: URL) -> UIImage {
		print("Download Started")
		getDataFromUrl(url: url) { data, response, error in
			guard let data = data, error == nil else { return }
			print(response?.suggestedFilename ?? url.lastPathComponent)
			print("Download Finished")
			DispatchQueue.main.async() {
				return UIImage(data: data)
			}
		}
		return UIImage()
	}
	
	func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
		URLSession.shared.dataTask(with: url) { data, response, error in
			completion(data, response, error)
			}.resume()
	}
	
}

extension MapViewController: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		// 3
		guard status == .authorizedAlways else {
			return
		}
		// 4
		locationManager.startUpdatingLocation()
		
		//5
		map.isMyLocationEnabled = true
		map.settings.myLocationButton = true
		
		
	}
	
	
	// 6
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let location = locations.first else {
			return
		}
		
		print("hit")
		
		locatiBS = location
		
		if let uid = Auth.auth().currentUser?.uid {
			
			Database.database().reference(withPath: "users").child(uid).child("location").updateChildValues(["lat": location.coordinate.latitude, "lon":location.coordinate.longitude])
			
			Database.database().reference(withPath: "users").child(uid).updateChildValues(["locationON": true])
			
			map.animate(toLocation: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
			
			map.animate(toZoom: 15.00)
			
			map.setMinZoom(1.0, maxZoom: 20)
			
		}
		
		// 7
		
		
		// 8
		//locationManager.stopUpdatingLocation()
	}
}
