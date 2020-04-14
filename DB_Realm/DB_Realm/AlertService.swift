//
//  AlertService.swift
//  DB_Realm
//
//  Created by thienle on 2/4/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import UIKit

class AlertService {
	private init() {}
	
	static func addAlert(in vc: UIViewController, completion: @escaping(String, Int?, String?) -> Void) {
		let alert = UIAlertController(title: "Add Line", message: nil, preferredStyle: .alert)
		alert.addTextField { (lineTF) in
			lineTF.placeholder = "Enter Pick Up Line"
		}
		alert.addTextField { (scoreTF) in
			scoreTF.placeholder = "Enter Score"
		}
		alert.addTextField { (emailTF) in
			emailTF.placeholder = "Enter Email"
		}
		
		let action = UIAlertAction(title: "Add", style: .default) { (_) in
			guard let line = alert.textFields?.first?.text,
				let scoreString = alert.textFields?[1].text,
				let emailString = alert.textFields?.last?.text
				else { return }
			let score = scoreString == "" ? nil : Int(scoreString)
			let email = emailString == "" ? nil : emailString
			
			completion(line,score,email)
		}
		
		alert.addAction(action)
		vc.present(alert, animated: true)
	}
	
	static func updateAlert(in vc: UIViewController, pickUpLine: Any, completion: @escaping(String, Int?, String?) -> Void) {
		let alert = UIAlertController(title: "Update Line", message: nil, preferredStyle: .alert)
		alert.addTextField { (lineTF) in
			lineTF.placeholder = "Enter Pick Up Line"
			lineTF.text = ""
		}
		alert.addTextField { (scoreTF) in
			scoreTF.placeholder = "Enter score"
			scoreTF.text = ""
		}
		alert.addTextField { (emailTF) in
			emailTF.placeholder = "Enter email"
			emailTF.text = ""
		}
		let action = UIAlertAction(title: "Update", style: .default) { (_) in
			guard let line = alert.textFields?.first?.text,
				let scoreString = alert.textFields?[1].text,
				let emailString = alert.textFields?.last?.text
				else { return }
			let score = scoreString == "" ? nil : Int(scoreString)
			let email = emailString == "" ? nil : emailString
			
			completion(line,score,email)
		}
		alert.addAction(action)
		vc.present(alert, animated: true)
	}
}
