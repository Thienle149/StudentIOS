//
//  RecentlyAddedCollectionViewCell.swift
//  AppMusic
//
//  Created by thienle on 3/21/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
import UIKit

class RecentlyAddedCollectionViewCell: UICollectionViewCell {

	@IBOutlet weak var backgroundImage: CustomImageView!
	@IBOutlet weak var song: UILabel!
	@IBOutlet weak var singer: UILabel!
	
	static let identifier: String = "RecentlyAddedCollectionViewCell"
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

	func setUp(_ model: MediaModel) {
		print("\(NetworkServices.hostname)/\(model.path!))")
		let size = CGSize(width: 200, height: 200)
		self.backgroundImage.loadImage(with: "\(NetworkServices.hostname)/\(model.path!)/\(UtilityFunc.formatImageOnURL(format: "jpeg", width: Int(size.width), height: Int(size.height)))", identifier: "\(model._id!)recent", type: .server, size: CGSize(width: size.width, height: size.height))
		self.song.text = model.name
		self.singer.text = model.author
	}
}
