//
//  SelectOneViewCell.swift
//  AppMusic
//
//  Created by thienle on 4/14/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
import UIKit

class SelectOneViewCell: UITableViewCell {
	static let identifer = "SelectOneViewCell"
	var radioButton: RadioButton!
	var label = UILabel()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.configRadioButton()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		
	}
	
	func configRadioButton() {
		radioButton = RadioButton()
		self.contentView.addSubview(radioButton)
		
		radioButton.snp.makeConstraints { (make) in
			make.top.trailing.bottom.leading.equalToSuperview().inset(8)
		}
	}
	
	func setUp(_ model: AnswerModel) {
		let checked = model.result == true ? EventRadio.checked : EventRadio.unchecked
		let color = model.repaired == true ? #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1) : #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
		self.radioButton.setUp(text: model.name, mode: .one, color: color)
		self.radioButton.setSelected(checked)
	}
}
