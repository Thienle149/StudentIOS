//
//  AppMusicFileManager.swift
//  AppMusic
//
//  Created by thienle on 4/2/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation

protocol AppMusicFileManagerProtocol {
	func importFile(_ folder : AppMusicFolder,type: MimeType?, name: String, content: Data?, attributes: [FileAttributeKey : Any]? , completion: @escaping (Bool) -> Void)
	func removeFile(_ folder : AppMusicFolder,type: MimeType?, name: String, attributes: [FileAttributeKey : Any]? , completion: @escaping (Bool) -> Void)
}
enum AppMusicFolder: String{
	
	case root = ""
	case resource = "Resource"
	case data = "Data"
	func getPath(childFolderPath: String? = nil) -> String {
		let documentDicrectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
		let path = "\(documentDicrectoryPath)/\(AppMusicFileManager.originFolder)/\(self.rawValue)/\(childFolderPath ?? "")"
		return path
	}
}
class AppMusicFileManager: AppMusicFileManagerProtocol {
	
	static let originFolder = "AppMusic"
	
	fileprivate var appDicrectoryPath: String!
	fileprivate let fileManager: FileManager!
	private static var instance: AppMusicFileManager!
	
	public static func getInstance() -> AppMusicFileManager {
		if instance == nil {
			instance = AppMusicFileManager()
		}
		return instance
	}
	
	init() {
		fileManager = FileManager.default
		self.createFolder(name: AppMusicFolder.root)
		
	}
	
	func createFolder(name: AppMusicFolder,folderChild: String? = nil) {
		let dictionaryPath = name.getPath(childFolderPath: folderChild)
		let isExit = fileManager.fileExists(atPath: dictionaryPath)
		if !isExit {
			do {
				try fileManager.createDirectory(atPath: dictionaryPath, withIntermediateDirectories: true, attributes: nil)
			} catch {
				print(error)
			}
		}
	}
	
	func importFile(_ folder : AppMusicFolder,type: MimeType? = nil, name: String, content: Data?, attributes: [FileAttributeKey : Any]? , completion: @escaping (Bool) -> Void) {
		//Create Folder
		createFolder(name: folder,folderChild: type?.getPath())
		//Paste file folder
		let filePath =  "\(folder.getPath(childFolderPath: type?.getPath()))/\(name)"
		let isExit = fileManager.fileExists(atPath: filePath)
		if !isExit {
			fileManager.createFile(atPath: filePath, contents: content, attributes: attributes)
			completion(true)
		} else {
			completion(false)
		}
	}
	
	func removeFile(_ folder : AppMusicFolder,type: MimeType? = nil, name: String, attributes: [FileAttributeKey : Any]? = nil , completion: @escaping (Bool) -> Void = {_ in }) {
		let filePath =  "\(folder.getPath(childFolderPath: type?.getPath()))/\(name)"
		let isExit = fileManager.fileExists(atPath: filePath)
		if isExit {
			do {
				try fileManager.removeItem(atPath: filePath)
				completion(true)
			} catch {
				print(error)
				completion(false)
			}
		}
	}
}
