//
//  ForYouCollectionViewCell.swift
//  AppMusic
//
//  Created by thienle on 3/24/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import UIKit

class ForYouCollectionViewCell: UICollectionViewCell {

	static let identifier: String = "ForYouCollectionViewCell"
	@IBOutlet weak var picture: UIImageView!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
	
	public func setUp(image: String) {
		self.picture.image = UIImage(named: image)
	}

}
