//
//  EventDetailTableViewController.swift
//  BikerStatus
//
//  Created by Chris T Stuart on 2/28/18.
//  Copyright © 2018 Chris T Stuart. All rights reserved.
//

import UIKit
import Firebase

class EventDetailTableViewController: UITableViewController {
	
	var venue: Venue!
	
	@IBOutlet weak var venueImage: UIImageView!
	
	@IBOutlet weak var venueTitle: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableView.rowHeight = 189;
		tableView.tableFooterView = UIView()
		
		venueImage.downloadImage(from: venue.imageVenu)
		venueTitle.text = venue.nameVenie
		
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// MARK: - Table view data source
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		return venue.dates.count
	}
	
	@IBAction func takeMeToEvent(_ sender: UIButton) {
		if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!))
		{
				UIApplication.shared.open(URL(string:"comgooglemaps://?center=\(venue.addressVenue)")!, options: [:], completionHandler: nil)
		}
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "eventDetailCell", for: indexPath) as! EventDetailTableViewCell
		
		cell.dateEvent.text = venue.dates[indexPath.row].time
		cell.descriptionEvent.text = venue.dates[indexPath.row].description
		cell.whereEvent.text = venue.dates[indexPath.row].location
		
		return cell
	}
	
}
