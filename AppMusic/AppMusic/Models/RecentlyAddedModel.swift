//
//  RecentlyAddedModel.swift
//  AppMusic
//
//  Created by thienle on 3/21/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
class RecentlyAddedModel {
	var pathImage: String
	var song: String
	var singer: String
	
	init(pathImage: String, song: String, singer: String) {
		self.pathImage = pathImage
		self.song = song
		self.singer = singer
	}
}
