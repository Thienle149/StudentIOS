//
//  ViewController.swift
//  DB_Realm
//
//  Created by thienle on 2/4/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
	
	
	@IBOutlet weak var tableview: UITableView!
	var pickUpLines: Results<PickUpLine>!
	var notificationToken: NotificationToken?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableview.dataSource = self
		tableview.delegate = self
		tableview.rowHeight = 100
		tableview.estimatedRowHeight = UITableView.automaticDimension
		
		let realm = RealmService.shared.realm
		pickUpLines = realm.objects(PickUpLine.self)
		
		notificationToken = realm.observe { (notification, realm) in
			self.tableview.reloadData()
		}
	}
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		print("willDisappear")
	}
	
	@IBAction func onAddTapped(_ sender: Any) {
		AlertService.addAlert(in: self) { (line, score, email) in
			let newPickUpLine = PickUpLine(line: line, score: score, email: email)
			RealmService.shared.create(newPickUpLine)
		}
	}
}

extension ViewController: UITableViewDataSource,UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return pickUpLines.count	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "PickUpLineCell") as? PickUpLineCell else { return UITableViewCell()}
		let pickUpLine = pickUpLines[indexPath.row]
		cell.configure(with: pickUpLine)
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let pickUpLine = pickUpLines[indexPath.row]
		AlertService.updateAlert(in: self, pickUpLine: pickUpLine) { (line, score, email) in
			let dict: [String: Any?] = ["line": line,"score": score,"email": email]
			RealmService.shared.update(pickUpLine, with: dict)
		}
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		guard editingStyle == .delete else { return }
		let pickUpLine = pickUpLines[indexPath.row]
		RealmService.shared.delete(pickUpLine)
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 100
	}
}
