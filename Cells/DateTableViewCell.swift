//
//  DateTableViewCell.swift
//  BikerStatus
//
//  Created by Chris T Stuart on 3/6/18.
//  Copyright © 2018 Chris T Stuart. All rights reserved.
//

import UIKit

class DateTableViewCell: UITableViewCell {

	@IBOutlet weak var address: UILabel!
	@IBOutlet weak var name: UILabel!
	@IBOutlet weak var venueImage: UIImageView!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
