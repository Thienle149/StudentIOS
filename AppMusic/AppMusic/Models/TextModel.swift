//
//  TextModel.swift
//  AppMusic
//
//  Created by thienle on 4/14/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
struct TextModel {
	var _id: String!
	var name: String!
	var date: Date?
	
	init (_id: String,name: String,date: Date?) {
		self._id = _id
		self.name = name
		self.date = date
	}
	
	init(dict: [String: Any?]) {
		if let _id = dict["_id"] as? String {
			self._id = _id
		}
		if let name = dict["name"] as? String {
			self.name = name
		}
		if let date = dict["date"] as? Date {
			self.date = date
		}
	}
}
