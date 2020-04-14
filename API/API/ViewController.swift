//
//  ViewController.swift
//  API
//
//  Created by thienle on 1/30/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
	
	@IBOutlet weak var searchBar: UISearchBar!
	var listOfHolidays = [HolidayDetail]() {
		didSet {
			DispatchQueue.main.async {
				self.tableView.reloadData()
				self.navigationItem.title = "\(self.listOfHolidays.count) Holidays foind"
			}
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		searchBar.delegate = self
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return listOfHolidays.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		let holiday = listOfHolidays[indexPath.row]
		cell.textLabel?.text = holiday.name
		cell.detailTextLabel?.text = holiday.date.iso
		print(holiday)
		return cell
	}
	
}

extension ViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		guard let searchBarText = searchBar.text else {return }
		let holidayRequest = HolidayRequest(countryCode: searchBarText)
		if searchBarText.isEmpty {
			listOfHolidays = []
		} else {
			holidayRequest.getHolidays {
				[weak self] result in
				switch result {
				case .failure(let error):
					print(error)
				case .success(let holidays):
					self?.listOfHolidays = holidays
				}
				
			}
		}
	}
}

