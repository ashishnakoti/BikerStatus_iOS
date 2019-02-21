//
//  EventsTableViewController.swift
//  BikerStatus
//
//  Created by Chris T Stuart on 2/28/18.
//  Copyright © 2018 Chris T Stuart. All rights reserved.
//

import UIKit
import Firebase

// do this file


class EventsTableViewController: UITableViewController {
	
	var events = [Event]()
	var venues = [Venue]()
	var index: IndexPath!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableView.rowHeight = 222;
		tableView.tableFooterView = UIView()
		
		var datesA = [Dates]()
		
		
		Database.database().reference(withPath: "events").observe(.value) { (snapshot) in
			if let value = snapshot.value as? [String:Any] {
				//print(value)
				for (key,eventInfo) in value {
					if let event = eventInfo as? [String:Any] {
						let mainName = key
						if let mainAddress = event["event_address"] as? String {
							if let mainDuration = event["event_duration"] as? String {
								if let mainImage = event["event_image"] as? String {
									if let contact_phone = event["event_contact_phone"] as? String {
										if let event_description = event["event_description"] as? String {
											if let event_host = event["event_host"] as? String {
												if let event_location = event["event_location"] as? String {
													if let event_type = event["event_type"] as? String {
														if let event_url = event["event_url"] as? String {
															if let event_zipcode = event["event_zipcode"] as? String {
																print(event_host)
																print(event_location)
																print(event_type)
																print(event_url)
																print(event_description)
																print(contact_phone)
															}
														}
													}
												}
											}
										}
									}
									self.events.append(Event(name: mainName, duration: mainDuration, address: mainAddress, image: mainImage, venues: self.venues))
									
									self.tableView.reloadData()
								}
							}
						}
					}
				}
			}
		}
		
		
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
		return events.count
	}
	
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "eventsCell", for: indexPath) as! EventTableViewCell
		
		cell.eventTitle.text = events.reversed()[indexPath.row].name
		cell.eventTime.text = events.reversed()[indexPath.row].duration
		cell.eventImage.downloadImage(from: events.reversed()[indexPath.row].image)
		
		// Configure the cell...
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		index = indexPath
		self.performSegue(withIdentifier: "date", sender: self)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if(segue.identifier == "date") {
			let segue = segue.destination as! DateTableViewController
			segue.eventsDates = self.events.reversed()[index.row]
		}
		
	}
	
}
