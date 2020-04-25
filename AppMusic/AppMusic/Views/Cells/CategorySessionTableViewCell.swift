//
//  CategoryTableViewCell.swift
//  AppMusic
//
//  Created by thienle on 3/21/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import UIKit

class CategorySessionTableViewCell: UITableViewCell {

	@IBOutlet weak var name: UILabel!
	static let identifier: String = "CategorySessionTableViewCell"
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func setUp(name: String) {
		self.name.text = name
	}
    
}
