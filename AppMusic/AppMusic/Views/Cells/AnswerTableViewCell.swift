//
//  AnswerTableViewCell.swift
//  AppMusic
//
//  Created by thienle on 4/16/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import UIKit

class AnswerTableViewCell: UITableViewCell {

	@IBOutlet weak var txtAnswer: UITextField!
	@IBOutlet weak var radio: RadioButtonV2!
	
	static let identifier: String = "AnswerTableViewCell"
	
	override func awakeFromNib() {
        super.awakeFromNib()
    }
	override func prepareForReuse() {
		self.txtAnswer.text = ""
		self.radio.check = .unchecked
	}
	
	func setUp(text: String, check: Bool) {
		txtAnswer.text = text
		let isCheck = check == true ? EventRadio.checked : EventRadio.unchecked
		radio.check = isCheck
	}
	
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
