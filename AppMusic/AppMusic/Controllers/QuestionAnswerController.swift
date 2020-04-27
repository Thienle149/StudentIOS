//
//  QuestionAnswerController.swift
//  AppMusic
//
//  Created by thienle on 4/14/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
import UIKit
class QuestionAnswerController: AppMusicController {
	var tableView: UITableView!
	var testCells: [TextCellModel] = []
	let sectionsName = ["Bài tập","Đã làm"]
	var testVCs: [TestController] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.textTitle = "Kiểm tra"
		self.commonUI()
		self.commonData()
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name(SocketEventName.on.test.rawValue), object: nil)
	}
	
	fileprivate func commonUI() {
		
		self.configTableView()
	}
	
	fileprivate func commonData() {
		getDataTestFromServer(look: { self.initTestControllers() }) {
			self.tableView.reloadData()
		}
		self.observeAppendTestFromServer()
		testCells.append(TextCellModel(open: false, name: sectionsName[1], contentRow: []))
	}
	
	fileprivate func observeAppendTestFromServer() {
		NotificationCenter.default.addObserver(forName: Notification.Name(SocketEventName.on.test.rawValue), object: nil, queue: nil) { [weak self](notification) in
			if let dictText = notification.object  as? [String: Any?] {
				if let section = self?.testCells.firstIndex(where: { (item) -> Bool in
					return item.name == self?.sectionsName[0]
				}) {
					self?.testCells[section].contentRow.append(TextModel(dict: dictText))
					if let open = self?.testCells[section].open, let count = self?.testCells[section].contentRow.count {
						if open {
							self?.tableView.beginUpdates()
							self?.tableView.insertRows(at: [IndexPath(row: count, section: section)], with: .none)
							self?.tableView.endUpdates()
						}
					}
				}
			}
		}
	}
	
	fileprivate func getDataTestFromServer(look: @escaping () -> Void = {},completion:@escaping () -> Void) {
		NetworkServices.getInstance().getData(route: "/test") { (dictTests, error) in
			if error == nil {
				if let dictTests = dictTests {
					var itemTests:[TextModel] = []
					for dictTest in dictTests {
						itemTests.append(TextModel(dict: dictTest))
						look()
					}
					self.testCells.append(TextCellModel(open: false, name: self.sectionsName[0], contentRow: itemTests))
					completion()
				}
			} else {
				AlertWhenUploadFile.getInstance(self.view).start(status: .failure, message: error as? String)
			}
		}
	}
	
	fileprivate func initTestControllers () {
		if let testVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TestController") as? TestController {
			self.testVCs.append(testVC)
		}
	}
	
	fileprivate func configTableView() {
		self.tableView = UITableView()
		self.contentView.addArrangedSubview(tableView)
		self.tableView.dataSource = self
		self.tableView.delegate = self
		
		let nibSessionText = UINib(nibName: CategorySessionTableViewCell.identifier, bundle: nil)
		let nibText = UINib(nibName: CategoryTableViewCell.identifier, bundle: nil)
		self.tableView.register(nibSessionText, forCellReuseIdentifier: CategorySessionTableViewCell.identifier)
		self.tableView.register(nibText, forCellReuseIdentifier: CategoryTableViewCell.identifier)
		
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 0
	}
}

extension QuestionAnswerController: UITableViewDataSource, UITableViewDelegate {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return testCells.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if testCells[section].open == false {
			return 1
		}
		return testCells[section].contentRow!.count + 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row == 0 {
			if let cell = tableView.dequeueReusableCell(withIdentifier: CategorySessionTableViewCell.identifier) as? CategorySessionTableViewCell {
				cell.setUp(name: testCells[indexPath.section].name)
				return cell
			}
		} else  {
			if let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as? CategoryTableViewCell {
				cell.setUp(text: testCells[indexPath.section].contentRow[indexPath.row - 1].name)
				return cell
			}
		}
		return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.row == 0 {
			tableView.beginUpdates()
			if testCells[indexPath.section].open == false {
				testCells[indexPath.section].open = true
			} else {
				testCells[indexPath.section].open = false
			}
			tableView.reloadSections(IndexSet(integer: indexPath.section), with: .none)
			tableView.endUpdates()
		} else {
			if let testId = self.testCells[indexPath.section].contentRow[indexPath.row - 1]._id,let testOpen = self.testCells[indexPath.section].contentRow[indexPath.row - 1].open {
				//				testVCs[indexPath.row - 1].setUp(testId)
				if let testVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TestController") as? TestController {
					testVC.setUp(testId,open: testOpen)
					self.present(testVC,animated: true,completion: {
						DispatchQueue.main.async {
							testVC.titleTest.title = self.testCells[indexPath.section].contentRow[indexPath.row - 1].name
						}
					})
				}
			}
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	
}
