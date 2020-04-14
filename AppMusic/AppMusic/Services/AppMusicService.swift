//
//  AppMusicService.swift
//  AppMusic
//
//  Created by thienle on 4/12/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
import UIKit
class AppMusicServices {
	
	private let postColorName = "GET COLOR BACKGROUND APPMUSIC"
	private static var instance: AppMusicServices!
	
	init() {
		
	}
	
	public static func getInstance() -> AppMusicServices {
		if instance == nil {
			instance = AppMusicServices()
		}
		return instance
	}
	
	func postColor(_ color: UIColor) {
		NotificationCenter.default.post(name: Notification.Name(postColorName), object: color)
	}
	
	func getColor(completion:@escaping (UIColor?)-> Void) {
		NotificationCenter.default.addObserver(forName: Notification.Name(postColorName), object: nil, queue: .main) { (notification) in
			if let color = notification.object as? UIColor {
				completion(color)
			} else {
				completion(nil)
			}
		}
	}
	
	func removeObserve(_ vc: UIViewController) {
		NotificationCenter.default.removeObserver(vc, name: Notification.Name(postColorName), object: nil)
	}
}
