//
//  Subject.swift
//  observer2
//
//  Created by thienle on 2/7/20.
//  Copyright © 2020 thienle. All rights reserved.
//


// Chứa đối tượng được các đối tượng khác theo dõi
import Foundation
class Subject {
	// observerArray : chứa các đối tượng theo dõi
	private var observerArray = [Observer]()
	private var _number = Int()
	
	// Thuộc tính number là thuộc tính được theo dõi
	var number: Int {
		set {
			_number = newValue
			self.notify()
		}
		get {
			return _number
		}
	}
	
	func attachObserver(observer: Observer) {
		observerArray.append(observer)
	}
	
	func removeObserver(observer: Observer) {
		observerArray = observerArray.filter({
			$0.id != observer.id
		})
	}
	// Khi number thay đổi thì nó sẽ gọi hàm update của từng đối tượng 1 đang theo dõi nó
	fileprivate func notify() {
		for observer in observerArray {
			observer.update()
		}
	}
}
