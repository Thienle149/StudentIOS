//
//  ExtensionUIImage.swift
//  AppMusic
//
//  Created by thienle on 4/7/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
	enum JPEGQuality: CGFloat {
		case lowest  = 0
		case low     = 0.25
		case medium  = 0.5
		case high    = 0.75
		case highest = 1
	}
	
	func jpeg(_ quality: JPEGQuality) -> UIImage  {
		if let data = self.jpegData(compressionQuality: quality.rawValue) {
			if let image = UIImage(data: data) {
				return image
			}
		}
		return self
	}
	
	func scaleImage(toSize newSize: CGSize) -> UIImage? {
		   var newImage: UIImage?
		   let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
		   UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
		   if let context = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage {
			   context.interpolationQuality = .high
			   let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
			   context.concatenate(flipVertical)
			   context.draw(cgImage, in: newRect)
			   if let img = context.makeImage() {
				   newImage = UIImage(cgImage: img)
			   }
			   UIGraphicsEndImageContext()
		   }
		   return newImage
	   }
	
	class func imageWithColor(color: UIColor, size: CGSize) -> UIImage? {
		let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
		UIGraphicsBeginImageContext(size)
		color.setFill()
		UIRectFill(rect)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return image
	}
}
