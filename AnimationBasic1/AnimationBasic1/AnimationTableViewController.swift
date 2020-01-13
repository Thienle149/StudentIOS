//
//  AnimationTableViewController.swift
//  AnimationBasic1
//
//  Created by thienle on 1/13/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
import UIKit

class AnimationTableViewController: UITableViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		animateTable()
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 50
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		cell.textLabel?.text = "Cool Effect \(indexPath.row) "
		return cell
	}

	
	func animateTable() {
		tableView.reloadData()
		let cells = tableView.visibleCells

		let tableViewHeight = tableView.bounds.size.height

		var delayCounter = 0
		for cell in cells {
			cell.transform = CGAffineTransform(scaleX: 0, y: tableViewHeight)
		}

		for cell in cells {
			UIView.animate(withDuration: 1.75, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveLinear, animations: {
				cell.transform = CGAffineTransform.identity
			}, completion: nil)
			delayCounter += 1
		}
	}
}
