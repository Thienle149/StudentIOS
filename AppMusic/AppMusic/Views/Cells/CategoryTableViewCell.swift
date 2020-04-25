//
//  CategoryTableViewCell.swift
//  AppMusic
//
//  Created by thienle on 3/31/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import UIKit
import RealmSwift
enum LoadType {
	case local
	case server
}
protocol ActionDownloadCategoryTableViewCell {
	func showButtonDownload() -> Bool
	func save(indexPath: IndexPath,mimeType: MimeType)
}
class CategoryTableViewCell: UITableViewCell {
	
	@IBOutlet weak var btnDownload: UIButton!
	@IBOutlet weak var imageCategory: CustomImageView!
	@IBOutlet weak var lblName: UILabel!
	fileprivate var cacheMedia: MediaModel?
	var mimeType: MimeType = .image
	fileprivate var indexPath: IndexPath?
	var delegateDownload: ActionDownloadCategoryTableViewCell? {
		didSet {
			if let delegate = self.delegateDownload {
				self.btnDownload.isHidden =  !delegate.showButtonDownload()
			}
		}
	}
	
	static let identifier = "CategoryTableViewCell"
	
	override func awakeFromNib() {
		super.awakeFromNib()
		self.btnDownload.isHidden = true
		
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
//		super.setSelected(selected, animated: animated)
	}
	
	func setUp(text: String?) {
		lblName.text = text
//		imageCategory.snp.makeConstraints({
//			$0.height.width.equalTo(0)
//		})
	}
	
	func setUp(media: MediaModel, index: IndexPath, type: LoadType) {
		self.lblName.text = media.name
		self.indexPath = index
		cacheMedia = media
		if assertMimeTypeTrue(media, type: .video) {
			self.mimeType = .video
			self.loadImageOfMediaWhenVideo(type: type, with: media)
		} else if assertMimeTypeTrue(media, type: .image) {
			self.mimeType = .image
			self.loadImageOfMediaWhenImage(type: type, with: media)
		}
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		DispatchQueue.main.async {
			self.imageCategory.image = nil
			self.textLabel?.text = nil
		}
	}
	
	fileprivate func loadImageOfMediaWhenVideo(type: LoadType, with media: MediaModel) {
		if type == .local {
			if let path = media.originalname{
				let urlMedia = URL(fileURLWithPath: "\(AppMusicFolder.resource.getPath(childFolderPath: mimeType.getPath()))/\(path)")
				DispatchQueue.main.async {
					self.imageCategory.image = UtilityFunc.generateThumnail(url: urlMedia)
				}
			}
		} else {
			// Server
			if self.imageCategory.image == nil {
				if let path = media.path, let urlMedia = URL(string: "\(NetworkServices.hostname)/\(path)") {
					DispatchQueue.main.async {
						self.imageCategory.image = UtilityFunc.generateThumnail(url: urlMedia)
					}
				}
			}
		}
	}
	
	fileprivate func loadImageOfMediaWhenImage(type: LoadType,with media: MediaModel) {
		var flagPath = ""
		let width = self.imageCategory.frame.size.width
		let hieght = self.imageCategory.frame.size.height
		
		if type == .local {
			if let path = media.originalname{
				flagPath = "\(AppMusicFolder.resource.getPath(childFolderPath: mimeType.getPath()))/\(path)"
				
			}
		} else {
			let format = "png"
			if let path = media.path {
				flagPath = "\(NetworkServices.hostname)/\(path)/\(UtilityFunc.formatImageOnURL(format: format, width: Int(width), height: Int(hieght)))"
			}
		}
		self.imageCategory.loadImage(with: flagPath, identifier: media._id, type: type, size: CGSize(width: width, height: hieght))
	}
	
	fileprivate func assertMimeTypeTrue(_ with: MediaModel,type: MimeType) -> Bool {
		if let result = (with.minetype?.contains(type.rawValue)) {
			return result
		}
		return false
	}
	
	@IBAction func downloadContent(_ sender: Any) {
		if let button = sender as? UIButton {
			animateOfButtonDownload(button) {
				if let indexPath = self.indexPath {
					self.delegateDownload?.save(indexPath: indexPath, mimeType: self.mimeType)
				}
			}
		}
	}
	
	fileprivate func animateOfButtonDownload(_ with: UIButton,_ completion: @escaping () -> Void) {
		UIView.transition(with: self, duration: TimeInterval(0.5), options: .transitionCrossDissolve, animations: {
			let space: CGFloat = 5.0
			with.imageEdgeInsets = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
		}) { (value) in
			if value {
				let space: CGFloat = 0.0
				with.imageEdgeInsets = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
				completion()
			}
		}
	}
	
}
