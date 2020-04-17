//
//  Pulses.swift
//  Form Engine
//
//  Created by thienle on 1/14/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
import UIKit
class Pulsing: CALayer {
	
	var animationGroup = CAAnimationGroup()
	// Properties
	private var initialPulseScale: Float = 0
	private var nextPulseAfter: TimeInterval = 0
	private var _duration: TimeInterval = 1.75
	private var radius: CGFloat = 100
	private var numberOfPulses: Float = Float.infinity
	
	private var from: Double = 0
	private var to: Double = 1
	
	override init(layer: Any) {
		super.init(layer:layer)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	init (numberOfPulses: Float = Float.infinity, radius: CGFloat, position: CGPoint,duration: TimeInterval = 1.75, from: Double = 0, to: Double = 1) {
		super.init()
		
		self.backgroundColor = UIColor.black.cgColor
		self.contentsScale = UIScreen.main.scale
		self.opacity = 0
		self.radius = radius
		self.numberOfPulses = numberOfPulses
		self.position = position
		self._duration = duration
		// Bounds
		self.bounds = CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2)
		self.cornerRadius = radius
		
		//
		DispatchQueue.global(qos: .default).async {
			self.setUpAnimationGroup(to: to, from: from)
			
			DispatchQueue.main.async {
				self.add(self.animationGroup, forKey: "pulse")
			}
		}
	}
	
	fileprivate func createSelectAnimation() -> CABasicAnimation? {
		let selectAnimation: CABasicAnimation = CABasicAnimation(keyPath: "path")
        selectAnimation.fromValue = UIBezierPath().cgPath
        selectAnimation.toValue = UIBezierPath().cgPath
		selectAnimation.fillMode = .forwards
        selectAnimation.isRemovedOnCompletion = false
		return selectAnimation
	}
	
	fileprivate func createScaleAnimation(to: Double, from: Double) -> CABasicAnimation? {
			let scaleAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
			scaleAnimation.fromValue = NSNumber(value: from)
			scaleAnimation.toValue = NSNumber(value: to)
			scaleAnimation.duration = _duration
			return scaleAnimation
		}
	
	fileprivate func createOpacityAnimation() -> CAKeyframeAnimation? {
		let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
		opacityAnimation.duration = _duration
		opacityAnimation.values = [0, 0.2, 0.8]
		opacityAnimation.keyTimes = [0, 0.2, 1]
		return opacityAnimation
	}
	
	fileprivate func setUpAnimationGroup(to: Double, from: Double) {
		self.animationGroup = CAAnimationGroup()
		self.animationGroup.duration = _duration + nextPulseAfter
		self.animationGroup.repeatCount = numberOfPulses
		
		let defaultCurve = CAMediaTimingFunction(name: .default)
		self.animationGroup.timingFunction = defaultCurve
		
		self.animationGroup.animations = [createScaleAnimation(to: to, from: from)!, createOpacityAnimation()!,createSelectAnimation()!]
	}
}
