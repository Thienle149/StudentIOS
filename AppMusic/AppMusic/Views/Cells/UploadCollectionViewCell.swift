//
//  UploadCollectionViewCell.swift
//  AppMusic
//
//  Created by thienle on 4/15/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import UIKit

class UploadCollectionViewCell: UICollectionViewCell {

	@IBOutlet weak var uploadImage: UIImageView!
	@IBOutlet weak var uploadTitle: UILabel!
	
	static let identifier = "UploadCollectionViewCell"
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
	
	func setUp(imageName: String?, title: String?) {
		if let name = imageName {
			let img = UIImage(named: name)
			self.uploadImage.image = img
		}
		if let title = title {
			self.uploadTitle.text = title
		}
	}

}
