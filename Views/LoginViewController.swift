//
//  LoginViewController.swift
//  BikerStatus
//
//  Created by Chris T Stuart on 2/24/18.
//  Copyright © 2018 Chris T Stuart. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwField: UITextField!
	@IBOutlet weak var backView: UIView!
	@IBOutlet weak var logIn: UIButton!
	var activity: NVActivityIndicatorView!
	
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		activity = NVActivityIndicatorView(frame: self.view.frame, type: .circleStrokeSpin, color: .black, padding: 100)
		
		
		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
		self.navigationController?.navigationBar.shadowImage = UIImage()
		self.navigationController?.navigationBar.isTranslucent = true
		self.navigationController?.view.backgroundColor = UIColor.clear
		
		self.logIn.layer.cornerRadius = 5
		self.backView.layer.cornerRadius = 5
		//self.backView.layer.masksToBounds = false
		self.backView.layer.shadowColor = UIColor.black.cgColor
		self.backView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
		self.backView.layer.shadowOpacity = 0.3
		self.backView.layer.shadowRadius = CGFloat(1.0)
		
		emailField.delegate = self
		pwField.delegate = self

        // Do any additional setup after loading the view.
    }

    
    @IBAction func loginPressed(_ sender: Any) {
		
		
        guard emailField.text != "", pwField.text != "" else {return}
        self.view.addSubview(activity)
        self.activity.startAnimating()
		
		
		Auth.auth().signIn(withEmail: emailField.text!, password: pwField.text!, completion: { (user, error) in
			self.activity.stopAnimating()
//			guard (error != nil) else {
//				print(error)
//				print(error?.localizedDescription)
//				return
//			}
			
			guard (user != nil) else {
                print(error?.localizedDescription as Any)
				return
			}
			
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let controller = storyboard.instantiateViewController(withIdentifier: "main")

			
			
			self.present(controller, animated: true, completion: nil)
           
        })
        
        
    }
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField == emailField {
			emailField.resignFirstResponder()
			pwField.becomeFirstResponder()
		} else if textField == pwField {
			pwField.resignFirstResponder()
		}
		return true
	}
    

}
