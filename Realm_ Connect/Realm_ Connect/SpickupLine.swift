//
//  SpickupLine.swift
//  Realm_ Connect
//
//  Created by thienle on 2/4/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
import RealityKit
class PickUpLine: Object {
	
	@objc dynamic var line: String = ""
	var score: Int?
	var email: String?
	
	convenience init(line: String, score: Int?, email: String?) {
		self.init()
		self.line = line
		self.score = score
		self.email = email
	}
}
