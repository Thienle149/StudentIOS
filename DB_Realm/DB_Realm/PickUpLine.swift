//
//  PickUpLine.swift
//  DB_Realm
//
//  Created by thienle on 2/4/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class PickUpLine: Object {
	
	dynamic var line: String = ""
	let score = RealmOptional<Int>()
	dynamic var email: String? = ""
	
	convenience init(line: String, score: Int?, email: String?) {
		self.init()
		self.line = line
		self.score.value = score
		self.email = email
	}
	
	func scoreString() -> String? {
		guard let score = score.value else { return  nil }
		return String(score)
	}
}
