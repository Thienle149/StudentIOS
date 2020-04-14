//
//  ObserverFunc.swift
//  observer2
//
//  Created by thienle on 2/7/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
protocol Observer {
	var id: Int { get set}
	func update() -> Void
}
