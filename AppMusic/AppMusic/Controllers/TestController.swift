//
//  TestController.swift
//  AppMusic
//
//  Created by thienle on 4/14/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
import UIKit
import SwiftGifOrigin

class TestController: UIViewController {
	@IBOutlet weak var navigationBar: UINavigationBar!
	@IBOutlet weak var titleTest: UINavigationItem!
	@IBOutlet weak var tableView: UITableView!
	var items: [QuestionModel] = []
	var selectOneViews: [SelectOneView] = []
	var testID: String = ""
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configTableView()
	}
	
//	deinit {
//		NotificationCenter.default.removeObserver(self, name: Notification.Name(SocketEventName.on.test_open.rawValue), object: nil)
//	}
	
	func setUp(_ testID: String, open: Bool) {
		self.testID = testID
		self.notifiStatusTestFromServer()
		AlertLoadingView.getInstance(self.view).start()
		if items.isEmpty {
			getDataAnswerQuestion(with: testID, look: { answers in
				self.addSelectView(answers)
			}) { [weak self] in
				if let view = self?.view {
				AlertLoadingView.getInstance(view).stop()
				}
				self?.tableView.isUserInteractionEnabled = open
				self?.tableView.tableFooterView = self?.footerView()
				self?.tableView.reloadData()
			}
		}
	}
	
	fileprivate func addSelectView(_ answers: [AnswerModel]) {
		let oneView = SelectOneView()
		oneView.setUp(answers)
		self.selectOneViews.append(oneView)
	}
	
	fileprivate func getDataAnswerQuestion(with id: String,look: @escaping ([AnswerModel]) -> Void,_ completion:@escaping () -> Void) {
		NetworkServices.getInstance().getData(route: "/test/id/\(id)") { (dictQuestions, error) in
			if error == nil {
				if let dictQuestions = dictQuestions {
					for dictQuestion in dictQuestions {
						let question = QuestionModel(dict: dictQuestion)
						self.items.append(question)
						look(question.answers)
					}
					completion()
				}
			} else  {
				AlertWhenUploadFile.getInstance(self.view).start(status: .failure,message: error as? String)
			}
		}
	}
	
	fileprivate func notifiStatusTestFromServer() {
		NotificationCenter.default.addObserver(forName: Notification.Name(SocketEventName.on.test_open.rawValue), object: nil, queue: .main) { [weak self](notification) in
			let dict = notification.object as? [String: Any?]
			if let _id = dict?["_id"] as? String,let open = dict?["open"] as? Bool {
				if self?.testID == _id  {
					self?.tableView.isUserInteractionEnabled = open
				}
			}
		}
	}
	
	@IBAction func back(_ sender: Any) {
		self.dismiss(animated: true) {
			
		}
	}
	
	fileprivate func configTableView() {
		self.tableView.dataSource = self
		self.tableView.delegate = self
		
		let nib = UINib(nibName: QuestionAnswerTableViewCell.identifier, bundle: nil)
		self.tableView.register(nib, forCellReuseIdentifier: QuestionAnswerTableViewCell.identifier)
		
		self.tableView.rowHeight = UITableView.automaticDimension
		self.tableView.estimatedRowHeight = UITableView.automaticDimension
		self.tableView.addObserver(self, forKeyPath: "TestControllerHeightTableView", options: .old, context: .none)
		
	}
	
	fileprivate func footerView() -> UIView {
		let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 100))
		let btnSend = UIButton()
		btnSend.setTitle("Send", for: .normal)
		btnSend.backgroundColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
		btnSend.layer.cornerRadius = 5
		btnSend.addTarget(self, action: #selector(sendServer), for: .touchUpInside)
		footerView.addSubview(btnSend)
		btnSend.snp.makeConstraints { (make) in
			make.centerX.centerY.equalToSuperview()
			make.width.equalTo(100)
		}
		return footerView
	}
	
	fileprivate func headerView(goal: Int, count: Int) -> UIView {
		let headerView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 200))
		headerView.contentMode = .scaleToFill
		let background = #imageLiteral(resourceName: "goal-backgroud-1")
		headerView.image = background
		let imageView = UIImageView()
		headerView.addSubview(imageView)
		imageView.snp.makeConstraints { (make) in
			make.centerY.equalToSuperview()
			make.leading.equalToSuperview().inset(8)
			make.width.height.equalTo(128)
		}
		let goodGifs = ["goal-2","goal-3","goal-4","goal-5"]
		let badGifs = ["goal-1","goal-6"]
		var imgGif = UIImage.gif(asset: goodGifs[Int.random(in: 0..<goodGifs.count)])
		if goal < count {
			imgGif = UIImage.gif(asset: badGifs[Int.random(in: 0..<badGifs.count)])
		}
		imageView.image = imgGif
		let goalView = UILabel()
		goalView.font = UIFont(name: AppMusicConfig.font, size: 72)
		goalView.textColor = .white
		goalView.text = "\(goal)/\(count)"
		headerView.addSubview(goalView)
		goalView.snp.makeConstraints { (make) in
			make.centerX.centerY.equalToSuperview()
		}
		return headerView
	}
	
	@objc func sendServer() {
		if authenticate() {
		let parameter: [String: Any] = ["questions": QuestionModel.convertDicts(items)]
		NetworkServices.getInstance().postData(route: "/question", parameters: parameter) { (dicts, error) in
			if error == nil {
				if let dicts = dicts {
					if let right = dicts[0]["right"] as? Int,let count = dicts[0]["count"] as? Int {
						
						
						self.tableView.tableHeaderView = self.headerView(goal: right, count: count)
						self.tableView.tableHeaderView?.layoutIfNeeded()
					}
					if let dictQuestions = dicts[0]["questions"] as? [[String: Any?]] {
						
						for i in 0..<dictQuestions.count {
							let _question = QuestionModel(dict: dictQuestions[i])
							let _answer = _question.answers[0]
							
							let questionIndex = self.items.firstIndex { (item) -> Bool in
								return item._id == _question._id
							}
							
							if let questionIndex = questionIndex {
								let answerIndex = self.items[questionIndex].answers.firstIndex { (item) -> Bool in
									return item._id == _answer._id
								}
								if let answerIndex = answerIndex {
									if _answer.repaired {
										self.items[questionIndex].answers[answerIndex].result = _answer.result
										self.items[questionIndex].answers[answerIndex].repaired = _answer.repaired
										self.selectOneViews[questionIndex].tableView.reloadRows(at: [IndexPath(row: answerIndex, section: 0)], with: .none)
									}
								}
								self.selectOneViews[questionIndex].isUserInteractionEnabled = false
								self.tableView.tableFooterView = nil
								self.tableView.contentOffset.y = 0
							}
						}
					}
					
				}
			}
		}
		} else {
			AlertWhenUploadFile.getInstance(self.view).start(status: .failure,message: "Vui lòng điền đủ câu trả lời")
		}
	}
	
	fileprivate func authenticate() -> Bool {
		for item in items {
			guard let _ = item.answers.first(where: { (answer) -> Bool in
				return answer.result == true
			}) else { return false }
		}
		return true
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
//			selectOneViews[indexPath.row].setUp(items[indexPath.row].answers)
			cell.setUp(question: items[indexPath.row].name ?? "", with: selectOneViews[indexPath.row])
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
