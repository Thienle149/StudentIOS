//
//  QuestionAnswerModel.swift
//  AppMusic
//
//  Created by thienle on 4/14/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
struct QuestionModel {
	var _id: String!
	var name: String!
	var textID: String!
	var answers: [AnswerModel] = []
	
	init(_id: String, question: String?, textID: String!, answers: [AnswerModel]) {
		self._id = _id
		self.name = question
		self.textID = textID
		self.answers = answers
	}
	
	init(question: String, answers:[AnswerModel]) {
		self.name = question
		self.answers = answers
	}
	
	init(dict: [String: Any?]) {
		if let _id = dict["_id"] as? String {
			self._id = _id
		}
		if let question = dict["name"] as? String {
			self.name = question
		}
		if let textID = dict["textID"] as? String {
			self.textID = textID
		}
		if let dictAnswers = dict["answers"] as? [[String: Any?]] {
			for dictAnswer in dictAnswers {
				answers.append(AnswerModel(dict: dictAnswer))
			}
		}
	}
	
	static func convertDict(_ model: QuestionModel) -> [String: Any] {
		var dictionary: [String: Any] = [:]
		dictionary["name"] = model.name
		var answers:[[String: Any?]] = []
		for answer in model.answers {
			answers.append(AnswerModel.convertDict(answer))
		}
		dictionary["answers"] = answers
		return dictionary
	}
	
	static func convertDicts(_ models: [QuestionModel]) -> [[String: Any]] {
		var dictionarys: [[String: Any]] = []
		for model in models {
			dictionarys.append(QuestionModel.convertDict(model))
		}
		return dictionarys
	}
	
}
