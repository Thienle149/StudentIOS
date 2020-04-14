//
//  realmServices.swift
//  Database_realm1
//
//  Created by thienle on 2/6/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
import RealmSwift

class RealmService {
	
	var realm = try! Realm()
	private static var instance: RealmService!
	public static func getInstance() -> RealmService {
		if instance == nil {
			instance = RealmService()
		}
		return instance
	}
	
	func create<T: Object>(_ object: T) {
		do {
			try realm.write {
				realm.add(object)
			}
		} catch {
			print(error)
		}
	}
	
	func update<T: Object>(_ object: T,with dictionary: [String: Any?]) {
		do {
			try realm.write {
				for (key, value) in dictionary {
					object.setValue(value, forKey: key)
				}
			}
		}catch {
			print(error)
		}
	}
	
	func delete<T: Object>(_ object: T) {
		do {
			try realm.write {
				realm.delete(object)
			}
		} catch {
			print(error)
		}
	}
}
