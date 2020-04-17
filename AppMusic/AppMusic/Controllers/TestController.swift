//
//  TestController.swift
//  AppMusic
//
//  Created by thienle on 4/14/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
import UIKit
class TestController: UIViewController {
	@IBOutlet weak var navigationBar: UINavigationBar!
	@IBOutlet weak var titleTest: UINavigationItem!
	@IBOutlet weak var tableView: UITableView!
	var items: [QuestionModel] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configTableView()
	}
	
	func setUp(_ testID: String) {
		if items.isEmpty {
		getDataAnswerQuestion(with: testID) { [weak self] in
			self?.tableView.reloadData()
			}
		}
	}
	
	fileprivate func getDataAnswerQuestion(with id: String,_ completion:@escaping () -> Void) {
		NetworkServices.getInstance().getData(route: "/test/id/\(id)") { (dictQuestions, error) in
			if error == nil {
				if let dictQuestions = dictQuestions {
					for dictQuestion in dictQuestions {
						self.items.append(QuestionModel(dict: dictQuestion))
					}
					completion()
				}
			} else  {
				AlertWhenUploadFile.getInstance(self.view).start(status: .failure,message: error as? String)
			}
		}
	}
	@IBAction func back(_ sender: Any) {
		self.dismiss(animated: true) {
			
		}
	}
	
	fileprivate func configTableView() {
		
		let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 100))
		footerView.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
		let btnSend = UIButton()
		btnSend.setTitle("Send", for: .normal)
		btnSend.backgroundColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
		btnSend.layer.cornerRadius = 5
		footerView.addSubview(btnSend)
		btnSend.snp.makeConstraints { (make) in
			make.centerX.centerY.equalToSuperview()
			make.width.equalTo(100)
		}
		self.tableView.tableFooterView = footerView
		
		self.tableView.dataSource = self
		self.tableView.delegate = self
		
		let nib = UINib(nibName: QuestionAnswerTableViewCell.identifier, bundle: nil)
		self.tableView.register(nib, forCellReuseIdentifier: QuestionAnswerTableViewCell.identifier)
		
		self.tableView.rowHeight = UITableView.automaticDimension
		self.tableView.estimatedRowHeight = UITableView.automaticDimension
		self.tableView.addObserver(self, forKeyPath: "TestControllerHeightTableView", options: .old, context: .none)
		
	}
	
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		self.tableView.snp.makeConstraints { (make) in
			make.height.equalTo(self.tableView.contentSize.height)
		}
	}
}

extension TestController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: QuestionAnswerTableViewCell.identifier) as? QuestionAnswerTableViewCell {
			let view = SelectOneView()
			view.setUp(items[indexPath.row].answers)
			cell.setUp(question: items[indexPath.row].name ?? "", with: view)
			return cell
		}
		return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	
	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
}
