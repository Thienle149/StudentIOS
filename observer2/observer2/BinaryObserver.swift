//
//  BinaryObserver.swift
//  observer2
//
//  Created by thienle on 2/7/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
class BinaryObserver: Observer {
	
	fileprivate var subject = Subject()
	var id: Int
	
	init (subject: Subject, id: Int) {
		self.subject = subject
		self.id = id
		subject.attachObserver(observer: self)
	}
	
	func update() {
		print("Binary: \(String(subject.number, radix: 2))")
	}
}
