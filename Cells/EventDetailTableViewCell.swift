//
//  EventDetailTableViewCell.swift
//  BikerStatus
//
//  Created by Chris T Stuart on 3/8/18.
//  Copyright © 2018 Chris T Stuart. All rights reserved.
//

import UIKit

class EventDetailTableViewCell: UITableViewCell {

	@IBOutlet var whereEvent: UILabel!
	@IBOutlet var dateEvent: UILabel!
	@IBOutlet var descriptionEvent: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
