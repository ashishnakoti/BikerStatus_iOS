//
//  Chat.swift
//  BikerStatus
//
//  Created by Myle$ on 3/6/18.
//  Copyright © 2018 Chris T Stuart. All rights reserved.
//

import Foundation


struct Chat {
    
    var text: String!
    var time: String!
    var userName: String!
    var sender: String!
	
	
	static func ==(lhs: Chat, rhs: Chat) -> Bool {
		return lhs.text == rhs.text
	}
    
    
}


