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
	
	func filledImage( _ fillColor: UIColor) -> UIImage {
		UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
		fillColor.setFill()
		if let context = UIGraphicsGetCurrentContext(){
			context.translateBy(x: 0, y: self.size.height)
			context.scaleBy(x: 1.0, y: -1.0)
			
			context.setBlendMode(CGBlendMode.colorBurn)
			let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
			context.draw(self.cgImage!, in: rect)
			
			context.setBlendMode(CGBlendMode.sourceIn)
			context.addRect(rect)
			context.drawPath(using: CGPathDrawingMode.fill)
		}
		
		let coloredImg : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		
		return coloredImg
	}
	
	func resizeImage( _ targetSize: CGSize) -> UIImage {
		let size = self.size
		
		let widthRatio  = targetSize.width  / self.size.width
		let heightRatio = targetSize.height / self.size.height
		
		// Figure out what our orientation is, and use that to form the rectangle
		var newSize: CGSize
		if(widthRatio > heightRatio) {
			newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
		} else {
			newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
		}
		
		// This is the rect that we've calculated out and this is what is actually used below
		let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
		
		// Actually do the resizing to the rect using the ImageContext stuff
		UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
		self.draw(in: rect)
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return newImage!
	}
	
	class func imageWithView(_ view: UIView) -> UIImage {
		UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0)
		defer { UIGraphicsEndImageContext() }
		view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
		return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
	}
}
