//
//  HandleAutoLayout.swift
//  AppMusic
//
//  Created by thienle on 3/29/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class UtilityFunc {
	
	class func configAutoLayout(parent: UIView, child: UIView) {
		child.translatesAutoresizingMaskIntoConstraints = false
		child.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
		child.trailingAnchor.constraint(equalTo: parent.trailingAnchor).isActive = true
		child.bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
		child.leadingAnchor.constraint(equalTo: parent.leadingAnchor).isActive = true
	}
	
	class func generateThumnail(url: URL) -> UIImage? {
		do {
			let asset = AVURLAsset(url: url)
			let imgGenerator = AVAssetImageGenerator(asset: asset)
			imgGenerator.appliesPreferredTrackTransform = true
			let cgImage = try imgGenerator.copyCGImage(at: .init(value: 0, timescale: 1), actualTime: nil)
			let thumbnail = UIImage(cgImage: cgImage)
			return thumbnail
			
		} catch {
			print("*** Error generating thumbnail: \(error)")
			return nil
		}
	}
	
	class func formatImageOnURL(format: String = "png",width: Int = 50,height: Int = 50) -> String {
		return "?format=\(format)&width=\(width)&height=\(height)"
	}
}
