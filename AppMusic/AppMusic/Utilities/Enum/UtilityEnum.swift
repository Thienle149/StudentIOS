//
//  UtilityEnum.swift
//  AppMusic
//
//  Created by thienle on 4/2/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
enum MimeType: String {
	case image = "image"
	case video = "video"
	
	func getPath() -> String {
		switch self {
		case .image:
			return "/Images"
		case.video:
			return "/Videos"
		}
	}
}
