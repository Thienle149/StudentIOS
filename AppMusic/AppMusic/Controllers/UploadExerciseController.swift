//
//  UploadExerciseController.swift
//  AppMusic
//
//  Created by thienle on 4/15/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
import UIKit

class UploadExerciseController: UIViewController {
	var txtQuestion: UITextView!
	@IBOutlet weak var tableViewAnswer: UITableView!
	@IBOutlet weak var imagePlus: UIImageView!
	@IBOutlet weak var questionContainer: UIView!
	
	var borderColor: CGColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
	var borderWidth: CGFloat = 2.0
	var cornerRadius: CGFloat = 5
	
	var itemAnswers:[AnswerModel] = []
	var itemQuestions:[QuestionModel] = []
	var test: TextModel!
	var testManagerVC: UploadExerciseToServerController!
	private var logError: String = ""
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.commonUI()
		self.commonData()
	}
	
	fileprivate func commonUI() {
		
		testManagerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: UploadExerciseToServerController.identifier) as? UploadExerciseToServerController
		testManagerVC.delegate = self
		
		let tap = UITapGestureRecognizer(target: self, action: #selector(tapView))
		self.view.addGestureRecognizer(tap)
		
		self.configTxtQuestion()
		self.configImagePlus()
		self.configTableViewAnswer()
	}
	
	fileprivate func commonData() {
		
	}
	
	@IBAction func back(_ sender: Any) {
		self.dismiss(animated: true) {}
	}
	
	@IBAction func next(_ sender: Any) {
		self.present(testManagerVC,animated: true)
		testManagerVC.setUp(itemQuestion: itemQuestions)
	}
	
	@IBAction func save(_ sender: Any) {
		if authenticateQuestion() {
			let question = QuestionModel(question: txtQuestion.text, answers: itemAnswers)
			self.itemQuestions.append(question)
			self.clearAnswer()
			AlertWhenUploadFile.getInstance(self.view).start(status: .success)
		} else {
			AlertWhenUploadFile.getInstance(self.view).start(status: .failure,message: logError)
		}
	}
	
	@objc func tapView() {
		self.view.endEditing(true)
	}
	
	fileprivate func configTxtQuestion() {
		self.txtQuestion = UITextView()
		self.questionContainer.addSubview(txtQuestion)
		txtQuestion.snp.makeConstraints { (make) in
			make.top.leading.bottom.trailing.equalToSuperview()
		}
		self.txtQuestion.layer.borderWidth = self.borderWidth
		self.txtQuestion.layer.borderColor = self.borderColor
		self.txtQuestion.layer.cornerRadius = self.cornerRadius
		self.txtQuestion.clipsToBounds = true
		self.txtQuestion.font = UIFont(name: AppMusicConfig.font, size: 17)
		self.txtQuestion.text = ""
	}
	
	fileprivate func configImagePlus() {
		let tap = UITapGestureRecognizer(target: self, action: #selector(addAnswer))
		self.imagePlus.isUserInteractionEnabled = true
		self.imagePlus.addGestureRecognizer(tap)
		self.imagePlus.image = UIImage(named: "plus")
	}
	
	@objc func addAnswer() {
		itemAnswers.append(AnswerModel())
		print("###\(itemAnswers)")
		let index = itemAnswers.count
		self.tableViewAnswer.beginUpdates()
		self.tableViewAnswer.insertRows(at: [IndexPath(row: index - 1, section: 0)], with: .none)
		self.tableViewAnswer.endUpdates()
	}
	
	fileprivate func configTableViewAnswer() {
		
		self.tableViewAnswer.dataSource = self
		self.tableViewAnswer.delegate = self
		
		self.tableViewAnswer.layer.cornerRadius = self.cornerRadius
		self.tableViewAnswer.layer.borderColor = self.borderColor
		self.tableViewAnswer.layer.borderWidth = self.borderWidth
		
		self.tableViewAnswer.rowHeight = UITableView.automaticDimension
		self.tableViewAnswer.estimatedRowHeight = UITableView.automaticDimension
		
		let nib = UINib(nibName: AnswerTableViewCell.identifier, bundle: nil)
		self.tableViewAnswer.register(nib, forCellReuseIdentifier: AnswerTableViewCell.identifier)
	}
	
	func clearAnswer() {
		txtQuestion.text = ""
		itemAnswers = []
		tableViewAnswer.reloadData()
	}
	
	fileprivate func isElementEmpty() -> Bool {
		return itemAnswers.contains { (item) -> Bool in
			return item.name == ""
		}
	}
	
	fileprivate func isRestulAnswersEmpty() -> Bool {
		return !itemAnswers.contains { (item) -> Bool in
			return item.result == true
		}
	}
	
	func authenticateQuestion() -> Bool {
		if !txtQuestion.text.isEmpty && !itemAnswers.isEmpty && itemAnswers.count != 0 && !isElementEmpty() && !isRestulAnswersEmpty() {
			return true
		}
		logError = "Vui lòng kiểm tra lại các trường đã nhập"
		return false
	}
}

extension UploadExerciseController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return itemAnswers.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		if let cell = tableView.dequeueReusableCell(withIdentifier: AnswerTableViewCell.identifier, for: indexPath) as? AnswerTableViewCell {
			cell.txtAnswer.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
			cell.setUp(text: itemAnswers[indexPath.row].name, check: itemAnswers[indexPath.row].result)
			cell.radio.onClick = click(_:)
			return cell
		}
		return UITableViewCell()
	}
	
	@objc func textDidChange(_ sender: UITextField) {
		for index in 0..<itemAnswers.count {
			if let cell = self.tableViewAnswer.cellForRow(at: IndexPath(row: index, section: 0)) as? AnswerTableViewCell {
				if cell.txtAnswer == sender {
					itemAnswers[index].name = sender.text
					break
				}
			}
		}
	}
	
	func click(_ sender: RadioButtonV2) {
		for index in 0..<itemAnswers.count {
			if let cell = self.tableViewAnswer.cellForRow(at: IndexPath(row: index, section: 0)) as? AnswerTableViewCell {
				if cell.radio == sender {
					let result = cell.radio.check == .checked ? true : false
					itemAnswers[index].result = result
				} else {
					itemAnswers[index].result = false
					cell.radio.check = .unchecked
				}
			}
		}
	}
}

extension UploadExerciseController: UploadExerciseToServerDelegate {
	func clearData() {
		self.clearAnswer()
		itemQuestions.removeAll()
	}
}
