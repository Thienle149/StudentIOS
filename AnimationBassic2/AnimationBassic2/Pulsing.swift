//
//  Pulsing.swift
//  AnimationBassic2
//
//  Created by thienle on 1/13/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import UIKit

class Pulsing: CALayer {
	var animationGroup = CAAnimationGroup()
	
	var initialPulseScale: Float = 0
	var nextPulseAfter: TimeInterval = 0
	var animationDuration: TimeInterval = 1.75
	var radius: CGFloat = 100
	var numberOfPulses: Float = Float.infinity
	
	override init(layer: Any) {
		super.init(layer: layer)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	init (numberOfPulses: Float = Float.infinity, radius: CGFloat, position: CGPoint,to: Double, from: Double) {
		super.init()
		
		self.backgroundColor = UIColor.black.cgColor
		self.contentsScale = UIScreen.main.scale
		self.opacity = 0
		self.radius = radius
		self.numberOfPulses = numberOfPulses
		self.position = position
		
		self.bounds = CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2)
		self.cornerRadius = radius
		
		DispatchQueue.global(qos: .default).async {
			self.setUpAnimationGroup(to: to, from: from)
			
			DispatchQueue.main.async {
				self.add(self.animationGroup, forKey: "pulse")
			}
		}
	}
	
	func createSelectAnimation() -> CABasicAnimation? {
		let selectAnimation: CABasicAnimation = CABasicAnimation(keyPath: "path")
        selectAnimation.fromValue = UIBezierPath().cgPath
        selectAnimation.toValue = UIBezierPath().cgPath
		selectAnimation.fillMode = .forwards
        selectAnimation.isRemovedOnCompletion = false
		return selectAnimation
	}
	
	func createScaleAnimation(to: Double, from: Double) -> CABasicAnimation? {
			let scaleAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
			scaleAnimation.fromValue = NSNumber(value: from)
			scaleAnimation.toValue = NSNumber(value: to)
			scaleAnimation.duration = animationDuration
			return scaleAnimation
		}
	
	func createOpacityAnimation() -> CAKeyframeAnimation? {
		let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
		opacityAnimation.duration = animationDuration
		opacityAnimation.values = [0, 0.2, 0.8]
		opacityAnimation.keyTimes = [0, 0.2, 1]
		return opacityAnimation
	}
	
	func setUpAnimationGroup(to: Double, from: Double) {
		self.animationGroup = CAAnimationGroup()
		self.animationGroup.duration = animationDuration + nextPulseAfter
		self.animationGroup.repeatCount = numberOfPulses
		
		let defaultCurve = CAMediaTimingFunction(name: .default)
		self.animationGroup.timingFunction = defaultCurve
		
		self.animationGroup.animations = [createScaleAnimation(to: to, from: from)!, createOpacityAnimation()!,createSelectAnimation()!]
	}
}


