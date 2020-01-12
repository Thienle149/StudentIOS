//
//  ViewController.swift
//  Animation
//
//  Created by thienle on 1/12/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}

	@IBAction func begineAnimation(_ sender: Any) {
		let viewToAnimate = UIView(frame: CGRect(x: 75, y: 75, width: 75, height: 75))
		viewToAnimate.backgroundColor = .orange
		self.view.addSubview(viewToAnimate)
	}
	
}

