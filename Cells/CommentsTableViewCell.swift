//
//  CommentsTableViewCell.swift
//  BikerStatus
//
//  Created by Chris T Stuart on 8/13/18.
//  Copyright © 2018 Chris T Stuart. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {

	@IBOutlet weak var profile_image: UIImageView!
	@IBOutlet weak var username: UILabel!
	@IBOutlet weak var cDescription: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
