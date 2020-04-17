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
	var testVC: TestController!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.textTitle = "Kiểm tra"
		self.commonUI()
		self.commonData()
	}
	
	fileprivate func commonUI() {
		testVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TestController") as? TestController
		self.configTableView()
	}
	
	fileprivate func commonData() {
		getDataTestFromServer {
			self.tableView.reloadData()
		}
		testCells.append(TextCellModel(open: false, name: sectionsName[1], contentRow: []))
	}
	
	fileprivate func getDataTestFromServer(_ completion:@escaping () -> Void) {
		NetworkServices.getInstance().getData(route: "/test") { (dictTests, error) in
			if error == nil {
				if let dictTests = dictTests {
					var itemTests:[TextModel] = []
					for dictTest in dictTests {
						itemTests.append(TextModel(dict: dictTest))
					}
					self.testCells.append(TextCellModel(open: false, name: self.sectionsName[0], contentRow: itemTests))
					completion()
				}
			} else {
				AlertWhenUploadFile.getInstance(self.view).start(status: .failure, message: error as? String)
			}
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
			if let testId = self.testCells[indexPath.section].contentRow[indexPath.row - 1]._id {
				testVC.setUp(testId)
				self.present(testVC,animated: true,completion: {
					self.testVC.titleTest.title = self.testCells[indexPath.section].contentRow[indexPath.row - 1].name
				})
			}
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	
}
