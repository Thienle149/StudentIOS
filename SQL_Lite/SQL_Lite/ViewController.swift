//
//  ViewController.swift
//  SQL_Lite
//
//  Created by thienle on 2/3/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import UIKit
import SQLite

class ViewController: UIViewController {
	
	var database: Connection? = nil
	
	let userTable = Table("users")
	let id = Expression<Int>("id")
	let name = Expression<String>("name")
	let password = Expression<String>("password")
	let email = Expression<String>("email")
	let note = Expression<String>("note")
	
	let alertController = UIAlertController(title: "Alert", message: "Plase enter User", preferredStyle: .alert)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setAlert()
		do {
			let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
			let fileUrl = documentDirectory.appendingPathComponent("user").appendingPathExtension("sqlite3")
			let database = try Connection(fileUrl.path)
			self.database = database
		} catch {
			print(error)
		}
	}

	func setAlert() {
		alertController.addTextField { (textField) in
			textField.placeholder = "Enter username..."
		}
		alertController.addTextField { (textField) in
			textField.placeholder = "Enter password ..."
			textField.isSecureTextEntry = true
		}
		
		let actLogin = UIAlertAction(title: "Insert", style: .default) { (action) in
			let username = self.alertController.textFields?[0].text ?? ""
			let password = self.alertController.textFields?[1].text ?? ""
			self.insertDB(username: username, password: password)
		}
		let actCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		alertController.addAction(actLogin)
		alertController.addAction(actCancel)
	}
	
	@IBAction func deleteUser(_ sender: Any) {
		let deleteTable = self.userTable.drop()
		do {
			try database?.run(deleteTable)
		} catch {
			print(error)
		}
	}
	@IBAction func createTable(_ sender: Any) {
		print("CREATE TAPPED")
		
		let createTable = self.userTable.create { (table) in
			table.column(self.id, primaryKey: true)
			table.column(self.name)
			table.column(self.password)
			table.column(self.email, defaultValue: "")
			table.column(note)
		}
		
		do {
			try self.database?.run(createTable)
			print("Created Table")
		} catch {
			print(error)
		}
	}
	@IBAction func insertUser(_ sender: Any) {
		self.present(alertController,animated: true, completion: nil)
	}
	
	func insertDB(username: String, password: String) {
		let insertUser = userTable.insert(self.note <- username, self.password <- password)
		do {
			try database?.run(insertUser)
			print("Insert user successed!")
			let list = try database?.prepare(userTable)
			for item in list! {
				print(item)
			}
		} catch {
			print(error)
		}
		
	}
	
}

