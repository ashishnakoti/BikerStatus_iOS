//
//  Event.swift
//  BikerStatus
//
//  Created by Myle$ on 3/4/18.
//  Copyright © 2018 Chris T Stuart. All rights reserved.
//

import Foundation


struct Event {
    
    var name: String!
    var duration: String!
    var address: String!
	var image: String!
	var venues: [Venue]!
	
	static func ==(lhs: Event, rhs: Event) -> Bool {
		return lhs.name == rhs.name
	}
	
}
