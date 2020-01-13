//
//  ViewController.swift
//  AnimationBasic1
//
//  Created by thienle on 1/13/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	@IBOutlet weak var button1Constraint: NSLayoutConstraint!
	@IBOutlet weak var button2Constraint: NSLayoutConstraint!
	
	var animationPerformedOnce: Bool = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		button1Constraint.constant -= view.bounds.width
		button2Constraint.constant -= view.bounds.width
	}
	
	
	override func viewDidAppear(_ animated: Bool) {
		if !animationPerformedOnce {
			//Animation for button1
			UIView.animate(withDuration: 0.5,delay: 0,options: .transitionFlipFromRight, animations: {
				self.button1Constraint.constant += self.view.bounds.width
				self.view.layoutIfNeeded()
			}, completion: nil)
			//Animation for button2
			UIView.animate(withDuration: 0.5,delay: 0.3,options: .curveEaseIn, animations: {
				self.button2Constraint.constant += self.view.bounds.width
				self.view.layoutIfNeeded()
			}, completion: nil)
		}
		animationPerformedOnce = true
	}
}

