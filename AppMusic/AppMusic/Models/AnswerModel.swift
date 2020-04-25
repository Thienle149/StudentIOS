//
//  AnswerModel.swift
//  AppMusic
//
//  Created by thienle on 4/14/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
class AnswerModel {
	var _id: String!
	var name: String!
	var result:Bool!
	var questionID: String!
	// Extra
	var repaired: Bool = false
	
	init() {
		//not use id when upload server is error
//		self._id  = ""
		self.name = ""
//		self.questionID = ""
		self.result = false
	}
	
	init(_id: String, name: String, questionID: String) {
		self._id = _id
		self.name = name
		self.questionID = questionID
	}
	
	init(dict: [String: Any?]) {
		if let _id = dict["_id"] as? String {
			self._id = _id
		}
		if let name = dict["name"] as? String {
			self.name = name
		}
		if let result = dict["result"] as? Bool {
			self.result = result
		}
		if let repaired = dict["repaired"] as? Bool {
			self.repaired = repaired
		}
		if let questionID = dict["questionID"] as? String {
			self.questionID = questionID
		}
	}
	
	static func convertDict(_ model: AnswerModel) -> [String: Any] {
		var dictionary: [String: Any] = [:]
		if model._id != nil {
			dictionary["_id"] = model._id
		}
		dictionary["name"] = model.name
		dictionary["result"] = model.result
		return dictionary
	}
}
