//
//  ViewController.swift
//  AnimationBassic2
//
//  Created by thienle on 1/13/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

	@IBOutlet weak var passwordTextField: ShakingTextField!
	@IBOutlet weak var avatarImageView: UIImageView!
	var isCheck: Bool = false

	var lay = CAShapeLayer()
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		passwordTextField.delegate = self
		
		let tap = UITapGestureRecognizer(target: self, action: #selector(addPulse))
		avatarImageView.isUserInteractionEnabled = true
		avatarImageView.addGestureRecognizer(tap)
		
	}
	
	@objc func addPulse() {
		if isCheck == false {
			let pulse = Pulsing(numberOfPulses: 1, radius: avatarImageView.frame.width, position: avatarImageView.center, to: 0.5 , from: 0)
		pulse.animationDuration = 0.75
		pulse.backgroundColor = UIColor.orange.cgColor
		self.view.layer.insertSublayer(pulse, below: avatarImageView.layer)
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
				self.lay.path = UIBezierPath(roundedRect: CGRect(x: self.avatarImageView.bounds.origin.x + 8, y: self.avatarImageView.bounds.origin.y + 8, width: 32, height: 32), cornerRadius: 16).cgPath
				self.lay.fillColor = UIColor.orange.cgColor
				self.avatarImageView.layer.addSublayer(self.lay)
		} else {
			let pulse = Pulsing(numberOfPulses: 1, radius: avatarImageView.frame.width, position: avatarImageView.center, to: 0 , from: 0.5)
			pulse.animationDuration = 0.75
			pulse.backgroundColor = UIColor.orange.cgColor
			self.view.layer.insertSublayer(pulse, below: avatarImageView.layer)
			self.lay.removeFromSuperlayer()
		}
		
		self.isCheck = !isCheck
	}

	func textFieldDidBeginEditing(_ textField: UITextField) {
		passwordTextField.shake()
	}
}

