//
//  Constants.swift
//  BikerStatus
//
//  Created by Chris T Stuart on 2/28/18.
//  Copyright © 2018 Chris T Stuart. All rights reserved.
//

import Firebase

struct Constants
{
	struct refs
	{
		static let databaseRoot = Database.database().reference()
		static let databaseChats = databaseRoot.child("chats")
	}
}
