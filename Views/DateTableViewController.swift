//
//  DateTableViewController.swift
//  BikerStatus
//
//  Created by Chris T Stuart on 3/6/18.
//  Copyright © 2018 Chris T Stuart. All rights reserved.
//

import UIKit

class DateTableViewController: UITableViewController {

	var eventsDates: Event!
	var index: IndexPath!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.tableView.rowHeight = 123
		self.title = eventsDates.name
		print(eventsDates)
		
    }
	
	override func viewDidAppear(_ animated: Bool) {

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
        return eventsDates.venues.count
    }

	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "datesCell", for: indexPath) as! DateTableViewCell
		cell.name.text = eventsDates.venues[indexPath.row].nameVenie
		cell.address.text = eventsDates.venues[indexPath.row].addressVenue
		cell.venueImage.downloadImage(from: eventsDates.venues[indexPath.row].imageVenu)
		
        return cell
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		index = indexPath
		performSegue(withIdentifier: "eventDetail", sender: self)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let segue = segue.destination as! EventDetailTableViewController
		segue.venue = eventsDates.venues[index.row]
	}

}
