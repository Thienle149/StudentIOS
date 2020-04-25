//
//  QuestionAnswerCellTableViewCell.swift
//  AppMusic
//
//  Created by thienle on 4/14/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import UIKit

class QuestionAnswerTableViewCell: UITableViewCell {

	@IBOutlet weak var questionText: UILabel!
	@IBOutlet weak var AnswerView: UIView!
	static let identifier = "QuestionAnswerTableViewCell"
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
	func setUp(question: String, with view: UIView){
		questionText.text = question
		AnswerView.addSubview(view)
		view.snp.makeConstraints { (make) in
			make.top.trailing.bottom.leading.equalToSuperview()
		}
	}
}
