//
//  OctalObserver.swift
//  observer2
//
//  Created by thienle on 2/7/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
class OctalObserver: Observer {
	
	fileprivate var subject = Subject()
	var id: Int
	
	init (subject: Subject, id: Int) {
		self.subject = subject
		self.id = id
		subject.attachObserver(observer: self)
	}
	
	func update() {
		print("Octal: \(String(subject.number, radix: 10))")
	}
}
