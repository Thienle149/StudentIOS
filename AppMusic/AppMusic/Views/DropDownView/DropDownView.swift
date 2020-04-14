//
//  DropDownView.swift
//  AppMusic
//
//  Created by thienle on 3/29/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
import UIKit
protocol DropDownDelegate {
	func didSelected(_ index: Int)
	func handleClose()
}
 protocol DropDownProtocol {
	var items: [CategoryModel] {get set}
	var delegate: DropDownDelegate? { get set }
	func open()
	func close()
	
}
class DropDownView: UIView, DropDownProtocol {
	var delegate: DropDownDelegate?
	
	func open() {
		DispatchQueue.main.async {
			self.isHidden = false
		}
	}
	
	func close() {
		delegate?.handleClose()
		DispatchQueue.main.async {
				self.isHidden = true
			}
	}
	
	
	@IBAction func btnClose(_ sender: Any) {
		close()
	}
	@IBOutlet weak var lblTitle: UILabel!
	@IBOutlet weak var BoundView: UIView!
	@IBOutlet var contentView: UIView!
	@IBOutlet weak var tableView: UITableView!
	
	let identifier = "DropDownView"
	var items: [CategoryModel] = [] {
		didSet {
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}
	
	
	required init(with: UIView,title: String, items:[CategoryModel]? = [] ) {
		super.init(frame: .zero)
		with.addSubview(self)
		self.isHidden = true
		UtilityFunc.configAutoLayout(parent: with, child: self)
		self.configContentView()
		self.configTableView()
		self.configBoundView()
		self.lblTitle.text = title
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	fileprivate func configBoundView() {
		self.BoundView.layer.borderWidth = 1
		self.BoundView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
		self.BoundView.layer.cornerRadius = 8
	}
	
	fileprivate func configTableView() {
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CELL")
		self.tableView.reloadData()
	}
	
	fileprivate func configContentView() {
		Bundle.main.loadNibNamed(self.identifier, owner: self, options: nil)
		self.addSubview(contentView)
		let color :UIColor = .white
		self.contentView.backgroundColor = color.withAlphaComponent(0.5)
		UtilityFunc.configAutoLayout(parent: self, child: contentView)
	}
}

extension DropDownView: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CELL")!
		cell.textLabel?.text = items[indexPath.row].name
			return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		delegate?.didSelected(indexPath.row)
		self.close()
	}
}
