//
//  CustomImageView.swift
//  AppMusic
//
//  Created by thienle on 3/31/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
import UIKit
let cacheImage: NSCache<NSString,UIImage> = NSCache<NSString,UIImage>()
class CustomImageView: UIImageView {
	
	typealias completionNonParameter = () -> Void
	
	var identifier: String?
	
	var localIdentifier: String?
	
	func loadImageFromContentFile(with path : String,identifier: String, completion: @escaping completionNonParameter) {
		self.identifier = identifier
		DispatchQueue.main.async {
			self.image = UIImage(named: "alert-fail")
		}
		
		if let imageFromCache = cacheImage.object(forKey: identifier as NSString) {
			DispatchQueue.main.async {
				self.image = imageFromCache
				completion()
			}
			return
		} else {
			if let imageFromLocal = UIImage(contentsOfFile: path) {
				cacheImage.setObject(imageFromLocal, forKey: identifier as NSString)
				if identifier == identifier {
					self.image = imageFromLocal
				}
			}
		}
	}
	
	func LoadImageFromURL(with strURL: String, identifier: String, completion: @escaping () -> Void = {}) {
		self.identifier = identifier
		DispatchQueue.main.async {
			self.image = UIImage(named: "alert-fail")
		}
		
		if let imageFromCache = cacheImage.object(forKey: identifier as NSString) {
			DispatchQueue.main.async {
				self.image = imageFromCache
				completion()
			}
			return
		} else {
			if let url = URL(string: strURL) {
				URLSession.shared.dataTask(with: url) { (data, res, err) in
					if let imageFromData = UIImage(data: data! ) {
						cacheImage.setObject(imageFromData, forKey: identifier as NSString)
						if self.identifier == identifier {
							DispatchQueue.main.async {
								self.image = imageFromData
								completion()
							}
						}
					}
				}.resume()
			}
		}
	}
	
	func loadImage(with: String,identifier: String,type: LoadType,size: CGSize, completion:@escaping completionNonParameter = {}) {
		self.identifier = identifier
		DispatchQueue.main.async {
			self.image = UIImage(named: "alert-fail")
		}
		
		if let imageFromCache = cacheImage.object(forKey: identifier as NSString) {
			DispatchQueue.main.async {
				self.image = imageFromCache.scaleImage(toSize: size)
				completion()
			}
			return
		} else {
			if type == .server {
				if let url = URL(string: with) {
					URLSession.shared.dataTask(with: url) { (data, res, err) in
						if let imageFromData = UIImage(data: data! )?.scaleImage(toSize: size) {
							cacheImage.setObject(imageFromData, forKey: identifier as NSString)
							if self.identifier == identifier {
								DispatchQueue.main.async {
									self.image = imageFromData
									completion()
								}
							}
						}
					}.resume()
				}
			} else if type == .local {
				if let imageFromLocal = UIImage(contentsOfFile: with)?.scaleImage(toSize: size) {
					cacheImage.setObject(imageFromLocal, forKey: identifier as NSString)
					if identifier == identifier {
						DispatchQueue.main.async {
							self.image = imageFromLocal
						}
					}
				}
			}
		}
	}
}
