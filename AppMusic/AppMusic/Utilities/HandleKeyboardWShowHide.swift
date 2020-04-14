//
//  HandleKeyboardWShowHide.swift
//  AppMusic
//
//  Created by thienle on 3/26/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation

import UIKit
class HandleKeyboardWShowHide {
	
	
	private static var instance: HandleKeyboardWShowHide!

	public static func getInstance() -> HandleKeyboardWShowHide{
		if instance == nil {
			instance = HandleKeyboardWShowHide()
		}
		return instance
	}
	
	init() {}
	
	func addObserver(queue: OperationQueue? = nil,completion:@escaping (Notification) -> Void) {
		let notificationCenter = NotificationCenter.default
		notificationCenter.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: queue) { (notificaton) in
			completion(notificaton)
		}
		notificationCenter.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: queue) { (notification) in
			completion(notification)
		}
	}
}
