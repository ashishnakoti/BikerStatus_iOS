//
//  UserCell.swift
//  InstagramLike
//
//  Created by Vasil Nunev on 29/11/2016.
//  Copyright © 2016 Vasil Nunev. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
	@IBOutlet weak var backView: UIView!
	var userID: String!
	
	override func awakeFromNib() {
		self.userImage.layer.cornerRadius = self.userImage.frame.width / 2
//		
//		backView.layer.cornerRadius = 5
//		self.backView.layer.masksToBounds = false
//		self.backView.layer.shadowColor = UIColor.black.cgColor
//		self.backView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
//		self.backView.layer.shadowOpacity = 0.3
//		self.backView.layer.shadowRadius = CGFloat(1.0)
	}

}
