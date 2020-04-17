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
	
	func configRadioButton() {
		radioButton = RadioButton()
		self.contentView.addSubview(radioButton)

		radioButton.snp.makeConstraints { (make) in
			make.top.trailing.bottom.leading.equalToSuperview().inset(8)
		}
//		self.contentView.addSubview(label)
//
//		label.snp.makeConstraints { (make) in
//			make.top.leading.bottom.trailing.equalToSuperview().inset(8)
//		}
	}
	
	func setUp(answer: String) {
		self.radioButton.setUp(text: answer, mode: .one)
//		label.numberOfLines = 0
//		label.lineBreakMode = .byWordWrapping
//		label.text = answer
//		label.sizeToFit()
	}
}
