//
//  RadioButton.swift
//  AnimationBasic1
//
//  Created by thienle on 1/13/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
import UIKit
class RadioButton: UIButton {
	
	private var layers: CAShapeLayer!
	private var isCheck: Bool = false {
		didSet {
			setRadioImage()
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	
	func commonInit() {
		layers = CAShapeLayer()
		layers.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 20, height: 20), cornerRadius: 20).cgPath
		layers.fillColor = UIColor.red.cgColor
		self.layer.addSublayer(layers)
		setRadioImage()
		self.addTarget(self, action: #selector(handleTouch(_:)) , for: .touchUpInside)
	}
	
	@objc func handleTouch(_ sender: Any?) {
		self.isCheck = !isCheck
		let button = sender as! UIButton
	}
	
	func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {

		let scale = newWidth / image.size.width
		let newHeight = image.size.height * scale
		UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
		image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
		let newImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()

		return newImage
	}
	func setRadioImage() {
		if isCheck {
			UIView.animate(withDuration: 0.5, animations: {
				let image = self.resizeImage(image: UIImage(named: "radio-check")!, newWidth: 30)
				self.setImage(image, for: .normal)
				self.layoutIfNeeded()
			}, completion: nil)
			
		} else {
			self.layers.isHidden = true
			let image = resizeImage(image: UIImage(named: "radio-uncheck")!, newWidth: 30)
			self.setImage(image, for: .normal)
		}
	}
}
