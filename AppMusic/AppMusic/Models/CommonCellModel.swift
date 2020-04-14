//
//  CommonCellModel.swift
//  AppMusic
//
//  Created by thienle on 3/28/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
enum StatusFetchData {
	case accept
	case disaccept
	case complete
}
struct CategoryCellModel {
	var open: Bool = false
	var isFetch: StatusFetchData = .disaccept
	var category: CategoryModel!
	var contentRow: [MediaModel]!
	
	init(_ dict: [String: Any?]) {
		self.category = CategoryModel(dict)
		if let dictMedias = dict["medias"] as? [[String: Any?]] {
			self.contentRow = []
			for dictMedia in dictMedias {
				self.contentRow.append(MediaModel(dictMedia))
			}
		}
	}
}
