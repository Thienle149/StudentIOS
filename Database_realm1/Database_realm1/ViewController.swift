//
//  ViewController.swift
//  Database_realm1
//
//  Created by thienle on 2/6/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		
		let realm = RealmService.getInstance().realm
	
		let listUser = realm.objects(Users.self)
		
		let user = Users(name: "user1", age: nil, email: "user1@gmail.com")
		RealmService.getInstance().create(user)
		
		for item in listUser {
			print(item)
		}
		
	}


}

