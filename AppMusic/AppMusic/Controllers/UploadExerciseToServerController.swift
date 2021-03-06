//
//  UploadExerciseToServerController.swift
//  AppMusic
//
//  Created by thienle on 4/16/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
protocol UploadExerciseToServerDelegate {
	func clearData()
	func remove(section: Int, row: Int?)
}
class UploadExerciseToServerController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	
	static let identifier = "UploadExerciseToServerController"
	var questionCells: [QuestionCellModel] = []
	var questions: [QuestionModel]! {
		didSet {
			self.headerViewCell.txtNumSubject.text = "\(self.questions.count)"
		}
	}
	var headerViewCell: TestHeaderView!
	var delegate: UploadExerciseToServerDelegate?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.commonUI()
		self.commonData()
	}
	
	@IBAction func back(_ sender: Any) {
		self.dismiss(animated: true) {}
	}
	
	@IBAction func upload(_ sender: Any) {
		if authenticate() {
			let name = headerViewCell.txtSubject.text!
			let questions = QuestionModel.convertDicts(self.questions)
			let parameter: [String: Any] = ["name": name,"questions": questions]
			
			NetworkServices.getInstance().postData(route: "/Test", parameters: parameter) { (dicts, error) in
				if error == nil {
					self.delegate?.clearData()
					self.clearAnswerQuestion()
					AlertWhenUploadFile.getInstance(self.view).start(status: .success)
				} else  {
					AlertWhenUploadFile.getInstance(self.view).start(status: .failure, message: error as? String)
				}
			}
		} else {
			AlertWhenUploadFile.getInstance(self.view).start(status: .failure,message: "Vui lòng kiểm tra các trường đã điền")
		}
	}
	
	fileprivate func commonUI() {
		self.configTableView()
	}
	
	fileprivate func commonData() {
		
	}
	
	fileprivate func clearAnswerQuestion() {
		questions = []
		questionCells = []
		self.headerViewCell.txtSubject.text = ""
		self.tableView.reloadData()
	}
	func setUp(itemQuestion: [QuestionModel]) {
		questions = itemQuestion
		questionCells = itemQuestion.map({ (item) -> QuestionCellModel in
			return QuestionCellModel(open: false, question: item)
		})
		
		self.tableView.reloadData()
	}
	
	fileprivate func configTableView() {
		
		headerViewCell = TestHeaderView(frame: CGRect(x: 0, y: 0, width: 0, height: 200))
		headerViewCell.setUp(number: questionCells.count, backgroundColor: #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1))
		self.tableView.tableHeaderView = headerViewCell
		
		self.tableView.dataSource = self
		self.tableView.delegate = self
		
		self.tableView.rowHeight = UITableView.automaticDimension
		self.tableView.estimatedRowHeight = UITableView.automaticDimension
		
		let nibCategorySessionCell = UINib(nibName: CategorySessionTableViewCell.identifier, bundle: nil)
		let nibCategoryCell = UINib(nibName: CategoryTableViewCell.identifier, bundle: nil)
		
		self.tableView.register(nibCategorySessionCell, forCellReuseIdentifier: CategorySessionTableViewCell.identifier)
		self.tableView.register(nibCategoryCell, forCellReuseIdentifier: CategoryTableViewCell.identifier)
	}
	
	fileprivate func authenticate() -> Bool{
		if let text = headerViewCell.txtSubject.text, !text.isEmpty && !questions.isEmpty {
			return true
		}
		return false
	}
}

extension UploadExerciseToServerController: UITableViewDataSource, UITableViewDelegate {
	func numberOfSections(in tableView: UITableView) -> Int {
		return questionCells.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if questionCells[section].open == false {
			return 1
		}
		if let count = questionCells[section].question?.answers.count {
			print("###\(count)")
		return count + 1
		}
		return 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row == 0 {
			if let cell = tableView.dequeueReusableCell(withIdentifier: CategorySessionTableViewCell.identifier, for: indexPath) as? CategorySessionTableViewCell {
				cell.setUp(name: questionCells[indexPath.section].question.name!)
				return cell
			}
		}else {
			
			if let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier) as? CategoryTableViewCell{
				cell.setUp(text: questionCells[indexPath.section].question.answers[indexPath.row - 1].name)
				return cell
			}
		}
		return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.row == 0 {
			if questionCells[indexPath.section].open == true{
				questionCells[indexPath.section].open = false
			} else {
				questionCells[indexPath.section].open = true
			}
			self.tableView.beginUpdates()
			self.tableView.reloadSections(IndexSet(integer: indexPath.section), with: .none)
			self.tableView.endUpdates()
		}
	}
	
	func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
		return .delete
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
		if indexPath.row != 0 {
			delegate?.remove(section: indexPath.section, row: indexPath.row - 1)
			self.tableView.beginUpdates()
			questions[indexPath.section].answers.remove(at: indexPath.row - 1)
			questionCells[indexPath.section].question.answers.remove(at: indexPath.row - 1)
			self.tableView.deleteRows(at: [indexPath], with: .none)
			self.tableView.endUpdates()
		} else {
			delegate?.remove(section: indexPath.section, row: nil)
			self.tableView.beginUpdates()
			questions.remove(at: indexPath.section)
			questionCells.remove(at: indexPath.section)
			self.tableView.deleteSections(IndexSet(integer: indexPath.section), with: .none)
			self.tableView.endUpdates()
		}
		}
	}
	
	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	
}
