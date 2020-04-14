//
//  File.swift
//  AppMusic
//
//  Created by thienle on 4/6/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
import SocketIO

class SocketServices: NSObject{
	
	var socket: SocketIOClient!
	lazy var manager: SocketManager = SocketManager(socketURL: URL(string: NetworkServices.hostname)!, config: [.log(true), .compress,.forcePolling(true)])
	private static var instance: SocketServices!
	
	public static func getInstance() -> SocketServices {
		if instance == nil {
			self.instance = SocketServices()
		}
		return instance
	}
	
	override init() {
		super.init()
		self.socket = manager.defaultSocket
		self.responseFromServer()
	}
	
	func establishSocket() {
		self.socket.connect()
	}
	
	func disConnectSocket() {
		self.socket.disconnect()
	}
	
	func responseFromServer() {
		self.observeMediaOfServer()
	}
	
	fileprivate func observeMediaOfServer() {
		self.socket.on(SocketEventName.on.media.rawValue) { (data, ack) in
			NotificationCenter.default.post(name: Notification.Name(SocketEventName.on.media.rawValue), object: data[0])
		}
	}
}
