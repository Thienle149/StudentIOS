//
//  Users.swift
//  Database_realm1
//
//  Created by thienle on 2/6/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
import RealmSwift
enum errorUser: Error {
	case isEmptyage
}
@objcMembers class Users: Object {
	dynamic var name: String = ""
	var age = RealmOptional<Int>()
	dynamic var email: String? = nil
	
	convenience init(name: String, age: Int?, email: String?) {
		
		self.init()
		self.name = name
		self.age.value = age
		self.email = email
		
	}
	
	func scoreString() -> String? {
		guard let age = age.value else { return nil }
		return String(age)
	}
}
