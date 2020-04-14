//
//  PickUpLineCell.swift
//  DB_Realm
//
//  Created by thienle on 2/5/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import UIKit

class PickUpLineCell: UITableViewCell {

	@IBOutlet weak var lineLabel: UILabel!
	@IBOutlet weak var scoreLabel: UILabel!
	@IBOutlet weak var emailLabel: UILabel!
	
	func configure(with pickUpLine: PickUpLine) {
		lineLabel.text = pickUpLine.line
		scoreLabel.text = pickUpLine.scoreString()
		emailLabel.text = pickUpLine.email
	}

}
