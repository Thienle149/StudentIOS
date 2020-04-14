//
//  RealmServices.swift
//  AppMusic
//
//  Created by thienle on 4/3/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
import RealmSwift

protocol RealmServicesProtocol {
	func create<T: Object>(_ object: T)
	func update<T: Object>(_ object: T, dict: [String: Any?])
	func delete<T: Object>(_ object: T)
}

class RealmServices: RealmServicesProtocol {

	init() {
		AppMusicFileManager.getInstance().createFolder(name: .data)
		if let url = URL(string: "\(AppMusicFolder.data.getPath())") {
			realm = try! Realm(fileURL: url.appendingPathComponent("AppMusic").appendingPathExtension("realm"))
		}
	}
	
	private var config: Realm.Configuration!
	private static var instance: RealmServices!
	
	static func getInstance() -> RealmServices {
		if instance == nil {
			instance = RealmServices()
		}
		return instance
	}
	
	var realm:Realm!
	
	func create<T:Object>(_ object: T) {
		do {
			try realm.write{
				realm.add(object)
			}
		} catch {
			post(error)
		}
	}
	
	func update<T: Object>(_ object: T, dict: [String: Any?]) {
		do {
			try realm.write {
				for (key,value) in dict {
					object.setValue(value, forKey: key)
				}
			}
		} catch {
			post(error)
		}
	}
	
	func delete<T: Object>(_ object: T) {
		do {
			try realm.write {
				realm.delete(object)
			}
		} catch {
			post(error)
		}
	}
	
	func post(_ error: Error) {
		NotificationCenter.default.post(name: NSNotification.Name("RealmError"), object: error)
	}
	
	func observeRealmError(completion: @escaping (Error?) -> Void) {
		NotificationCenter.default.addObserver(forName: NSNotification.Name("RealmError"), object: nil, queue: nil) { (notification) in
			completion(notification.object as? Error)
		}
	}
	
	func stopObservingError(in vc: UIViewController) {
		NotificationCenter.default.removeObserver(vc, name: NSNotification.Name("RealmError"), object: nil)
	}
}
