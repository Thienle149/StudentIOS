//
//  HexObserver.swift
//  observer2
//
//  Created by thienle on 2/7/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
class HexObserver: Observer {
	
	fileprivate var subject = Subject()
	var id: Int
	
	init (subject: Subject, id: Int) {
		self.subject = subject
		self.id = id
		subject.attachObserver(observer: self)
	}
	
	func update() {
		print("Hex: \(String(subject.number, radix: 16))")
	}
}
