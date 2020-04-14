//
//  FunkyHomeViewModel.swift
//  RxSwft_Bind
//
//  Created by thienle on 2/13/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation

protocol FunkyHomeViewProtocol {
	var items: [FunkyButtonProtocol] { get }
}

class FunkyHomeViewModel: FunkyHomeViewProtocol {
	
	var items: [FunkyButtonProtocol] = []
	init() {
		
		let one = FunkyButtonModelView(title: "one")
		let two = FunkyButtonModelView(title: "two")
		let three = FunkyButtonModelView(title: "three")
		let four = FunkyButtonModelView(title: "four")
		let five = FunkyButtonModelView(title: "five")
		let six = FunkyButtonModelView(title: "six")
		
		items.append(contentsOf: [one,two,three,four,five,six])
	}
	
}
