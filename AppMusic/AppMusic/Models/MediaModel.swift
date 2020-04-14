//
//  MediaModel.swift
//  AppMusic
//
//  Created by thienle on 3/27/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
import RealmSwift

class  MediaModel: Object{
	@objc dynamic var _id: String!
	@objc dynamic var name: String!
	@objc dynamic var author: String!
	@objc dynamic var path: String?
	var size = RealmOptional<Int>()
	@objc dynamic var date: Date?
	@objc dynamic var categoryID: String?
	@objc dynamic var minetype: String?
	@objc dynamic var originalname: String!
	
	init(name: String,author: String,categoryID: String) {
		self.name = name
		self.author = author
		self.categoryID = categoryID
	}
	
	init(_ dict: [String:Any?]) {
		if let _id = dict["_id"] as? String {
			self._id = _id
		}
		if let name = dict["name"] as? String {
			self.name = name
		}
		if let author = dict["author"] as? String {
			self.author = author
		}
		if let path = dict["path"] as? String {
			self.path = path
		}
		if let size = dict["size"] as? RealmOptional<Int> {
			self.size = size
		}
		if let date = dict["date"] as? Date {
			self.date = date
		}
		if let categoryID = dict["categoryID"] as? String {
			self.categoryID = categoryID
		}
		if let mimetype = dict["mimetype"] as? String {
			self.minetype = mimetype
		}
		if let originalname = dict["originalname"] as? String {
				self.originalname = originalname
			}
	}
	
	required init() {
		
	}
	
	func convertDict() -> [String: Any] {
		return [
			"name":self.name ?? "",
			"author": self.author ?? "",
			"categoryID": self.categoryID ?? ""
		]
	}
}
