//
//  CategoryModel.swift
//  AppMusic
//
//  Created by thienle on 3/29/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
struct CategoryModel {
	
	var _id: String!
	var name: String!
	var image: String?
	var date: Date!
	
	
	init(_ dict: [String: Any?]) {
		if let _id = dict["_id"] as? String {
			self._id = _id
		}
		if let name = dict["name"] as? String {
			self.name = name
		}
		if let image = dict["image"] as? String {
			self.image = image
		}
		
		if let date = dict["date"] as? Date {
			self.date = date
		}
	}
}
