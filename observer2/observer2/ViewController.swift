//
//  ViewController.swift
//  observer2
//
//  Created by thienle on 2/7/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		let subject = Subject()

		let binary = BinaryObserver(subject: subject, id: 1)
		let _ = OctalObserver(subject: subject, id: 2)
		let _ = HexObserver(subject: subject, id: 3)

		subject.number = 15
		subject.removeObserver(observer: binary)
		subject.number = 2
	}


}

