//
//  SocketEventName.swift
//  AppMusic
//
//  Created by thienle on 4/7/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation

class SocketEventName {
	enum emit: String {
		case media = "server-on-data-media"
		case medias = "server-on-data-medias"
		case test = "server-on-data-test"
	}
	enum on: String {
		case media = "server-emit-data-media"
		case medias = "server-emit-data-medias"
		case test = "server-emit-data-test"
	}
}
