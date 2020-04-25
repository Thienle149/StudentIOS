//
//  SelectOneView.swift
//  AppMusic
//
//  Created by thienle on 4/14/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
import UIKit
class SelectOneView: UIView, UITableViewDataSource, UITableViewDelegate {
	var tableView: UITableView!
	var heightTableView: NSLayoutConstraint!
	static let observerHeightTableView = "heightTableViewSelectOneView"
	var items: [AnswerModel] = [] {
		didSet{
			self.tableView.reloadData()
		}
	}
	
	init() {
		super.init(frame: .zero)
		self.tableView = UITableView()
		self.addSubview(tableView)
		
		self.tableView.snp.makeConstraints { (make) in
			make.top.trailing.bottom.leading.equalToSuperview()
		}
		heightTableView = self.tableView.heightAnchor.constraint(greaterThanOrEqualToConstant: 201)
		heightTableView.isActive = true
		self.tableView.dataSource = self
		self.tableView.delegate = self
		self.tableView.register(SelectOneViewCell.self, forCellReuseIdentifier: SelectOneViewCell.identifer)
		
		self.tableView.rowHeight = UITableView.automaticDimension
		self.tableView.estimatedRowHeight = UITableView.automaticDimension
		self.tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: .none)
		
	}
	
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		DispatchQueue.main.async {
			self.heightTableView.constant = self.tableView.contentSize.height
		}
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	func setUp(_ items: [AnswerModel]) {
		self.items = items
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: SelectOneViewCell.identifer) as! SelectOneViewCell
		
		cell.setUp(items[indexPath.row])
		cell.radioButton.onClick = onClickAnswer(_:)
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	
	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	
	fileprivate func onClickAnswer(_ sender: RadioButton) {
		for index in 0..<items.count {
			if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? SelectOneViewCell {
				if cell.radioButton == sender {
					let checked = cell.radioButton.checked == .checked ? true : false
					items[index].result = checked
				} else {
					items[index].result = false
					cell.radioButton.setSelected(.unchecked)
				}
			}
		}
	}
}


