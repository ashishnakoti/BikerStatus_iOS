//
//  Post.swift
//  BikerStatus
//
//  Created by Chris T Stuart on 2/24/18.
//  Copyright © 2018 Chris T Stuart. All rights reserved.
//

import UIKit

class Post: NSObject {
	
	
	var author: String!
	var likes: Int!
	var pathToImage: String!
	var userID: String!
	var postID: String!
	var postDescription: String!
	var userImage: String!
	
	var peopleWhoLike: [String] = [String]()
	
	static func ==(lhs: Post, rhs: Post) -> Bool {
		return lhs.postID == rhs.postID
	}
}

