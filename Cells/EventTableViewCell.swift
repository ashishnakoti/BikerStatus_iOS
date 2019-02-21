//
//  EventTableViewCell.swift
//  BikerStatus
//
//  Created by Chris T Stuart on 3/6/18.
//  Copyright © 2018 Chris T Stuart. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
	@IBOutlet weak var eventImage: UIImageView!
	
	@IBOutlet weak var eventTitle: UILabel!
	
	@IBOutlet weak var eventTime: UILabel!
	
	@IBOutlet weak var shadowView: UIView!
	@IBOutlet weak var backView: UIView!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		shadowView.layer.cornerRadius = 5
		eventImage.layer.cornerRadius = 5
		backView.layer.cornerRadius = 5
		self.backView.layer.masksToBounds = false
		self.backView.layer.shadowColor = UIColor.black.cgColor
		self.backView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
		self.backView.layer.shadowOpacity = 0.3
		self.backView.layer.shadowRadius = CGFloat(1.0)
		
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
