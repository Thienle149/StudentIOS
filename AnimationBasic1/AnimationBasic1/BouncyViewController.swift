//
//  BouncyViewController.swift
//  AnimationBasic1
//
//  Created by thienle on 1/13/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
import UIKit

class BounceViewController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	@IBAction func animationBounce(_ sender: Any) {
		let buttonAnimation = sender as! UIButton
		let bounds = buttonAnimation.bounds
		UIView.animate(withDuration: 100, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 100, options: .curveEaseInOut, animations: {
			buttonAnimation.bounds = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width + 60, height: bounds.height)
		}) { (success) in
			if success {
				UIView.animate(withDuration: 100, animations: {
					buttonAnimation.bounds = bounds
				})
			}
		}
		
		
	}
	
}
