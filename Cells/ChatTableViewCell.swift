//
//  ChatTableViewCell.swift
//  BikerStatus
//
//  Created by Chris T Stuart on 3/6/18.
//  Copyright © 2018 Chris T Stuart. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

	@IBOutlet weak var userImage: UIImageView!
	@IBOutlet weak var userName: UILabel!
	@IBOutlet weak var lastMessage: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
