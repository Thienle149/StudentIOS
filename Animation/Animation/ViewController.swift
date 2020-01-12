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
		
		let startPoint = CGPoint(x: 75, y: 75)
		let endPoint = CGPoint(x: 75, y: 175)
		let duration: Double = 4.0
		let postionAnimation = contructPostionAnimation(startPoint: startPoint, endPoint: endPoint, animationDuration: duration)
		viewToAnimate.layer.add(postionAnimation, forKey: "position")
		viewToAnimate.layer.position = endPoint

				let scaleAnimation = constructScaleAnimation(startingScale: 1.0, endingScale: 0, animationDuration: 2.5)
		viewToAnimate.layer.add(scaleAnimation, forKey: "scale")
		
		let rotationAnimation = constructRotationAnimation(animationDuration: 1)
		viewToAnimate.layer.add(rotationAnimation, forKey: "rotation")
		
		let opacityFadeAnimation = constructOpacityAnimation(startingOpacity: 1.0, endingOpacity: 0.0, animationDuration: 2.5)
		viewToAnimate.layer.add(opacityFadeAnimation, forKey: "opacity")
		
	}
	
	private func contructPostionAnimation(startPoint: CGPoint, endPoint: CGPoint,animationDuration: Double) -> CABasicAnimation {
		let postionAnimation = CABasicAnimation(keyPath: "position")
		postionAnimation.fromValue = NSValue(cgPoint: startPoint)
		postionAnimation.toValue = NSValue(cgPoint: endPoint)
		postionAnimation.duration = animationDuration
		postionAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
		return postionAnimation
	}
	
	private func constructScaleAnimation(startingScale: CGFloat, endingScale: CGFloat, animationDuration: Double) ->CABasicAnimation {
		let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
		scaleAnimation.fromValue = startingScale
		scaleAnimation.toValue = endingScale
		scaleAnimation.duration = animationDuration
		scaleAnimation.autoreverses = true
		return scaleAnimation
	}
	
	private func constructRotationAnimation(animationDuration: Double)-> CABasicAnimation {
		let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
		rotationAnimation.fromValue = 0
		rotationAnimation.toValue = Double.pi * 5
		rotationAnimation.duration = animationDuration
		rotationAnimation.repeatCount = Float.infinity
		return rotationAnimation
	}
	
	private func constructOpacityAnimation(startingOpacity: CGFloat, endingOpacity: CGFloat, animationDuration: Double) -> CABasicAnimation {
		let opacityFadeAnimation = CABasicAnimation(keyPath: "opacity")
		opacityFadeAnimation.fromValue = startingOpacity
		opacityFadeAnimation.toValue = endingOpacity
		opacityFadeAnimation.duration = animationDuration
		opacityFadeAnimation.autoreverses = true
		opacityFadeAnimation.repeatCount = Float.infinity
		return opacityFadeAnimation
	}
}

