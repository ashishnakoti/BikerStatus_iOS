//
//  ViewController.swift
//  BikerStatus
//
//  Created by Chris T Stuart on 2/24/18.
//  Copyright © 2018 Chris T Stuart. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
		self.navigationController?.navigationBar.shadowImage = UIImage()
		self.navigationController?.navigationBar.isTranslucent = true
		self.navigationController?.view.backgroundColor = UIColor.clear
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func openTerms(_ sender: UIButton) {
		
		UIApplication.shared.open(URL(string : "https://www.dropbox.com/s/so0w5cy3pu8p1zd/LawDepot%20-%20EULA.pdf?dl=0")!, options: [:], completionHandler: { (status) in
			
		})
		
	}
	
}

