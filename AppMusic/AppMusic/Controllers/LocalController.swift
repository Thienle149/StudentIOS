//
//  LocalController.swift
//  AppMusic
//
//  Created by thienle on 4/3/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import AVFoundation
import AVKit
import SnapKit

class LocalController: AppMusicController {
	var tableView: UITableView!
	var medias: [MediaModel] = []
	var notificationToken: NotificationToken!
	 var imageController: MediaController!
	lazy var videoController: AVPlayerViewController = AVPlayerViewController()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.textTitle = "Local"
		self.commonUI()
		self.commonData()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		//		notificationToken.invalidate()
		//		RealmServices.getInstance().stopObservingError(in: self)
	}
	
	fileprivate func commonUI() {
		imageController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MediaController") as? MediaController
		self.configTableView()
	}
	
	
	fileprivate func commonData() {
		medias.append(contentsOf: RealmServices.getInstance().realm.objects(MediaModel.self))
		tableView.reloadData()
		NotificationCenter.default.addObserver(forName: Notification.Name("NotifyMedias"), object: nil, queue: .none) {[weak self](notification) in
			if let media = notification.object as? MediaModel {
				self?.medias.append(media)
				self?.tableView.beginUpdates()
				self?.tableView.insertRows(at: [IndexPath(row: (self?.medias.count)! - 1, section: 0)], with: .none)
				self?.tableView.endUpdates()
				
			}
		}
	}
	
	fileprivate func configTableView() {
		self.tableView = UITableView()
		self.addWidget(title: "", with: tableView)
		self.tableView.dataSource = self
		self.tableView.delegate = self
		
		let nibCategoryCell = UINib(nibName: CategoryTableViewCell.identifier, bundle: nil)
		self.tableView.register(nibCategoryCell, forCellReuseIdentifier: CategoryTableViewCell.identifier)
	}
	
	deinit {
		notificationToken.invalidate()
		RealmServices.getInstance().stopObservingError(in: self)
		
	}
}

extension LocalController: UITableViewDataSource, UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return medias.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as? CategoryTableViewCell {
			let objMedia = medias[indexPath.row]
			cell.setUp(media: objMedia, index: indexPath, type: .local)
			return cell
		}
		return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let cell = tableView.cellForRow(at: indexPath) as? CategoryTableViewCell {
			let mimeType = cell.mimeType
			self.loadMediaController(medias[indexPath.row],with: mimeType)
		}
	}
	
	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let delete = deleteAction(indexPath)
		let update = updateAction(indexPath)
		return UISwipeActionsConfiguration(actions: [delete,update])
	}
	
	fileprivate func loadMediaController(_ media: MediaModel,with mimeType: MimeType) {
		if mimeType == .video {
			if let path = media.path, let url = URL(string: "\(NetworkServices.hostname)/\(path)") {
				let videoPlayer = AVPlayer(url: url)
				videoController.player = videoPlayer
				videoController.delegate = self
				self.present(videoController,animated: true,completion: {
					videoPlayer.play()
				})
			}
		} else if mimeType == .image {
			self.present(imageController,animated: true,completion: {
				DispatchQueue.main.async {
					self.imageController.imageMedia.image = UIImage(contentsOfFile: "\(AppMusicFolder.resource.getPath(childFolderPath: "/Images"))/\(media.originalname!)")
				}
			})
		}
	}
	
	fileprivate func deleteAction(_ indexPath: IndexPath) -> UIContextualAction {
		var mimeType = MimeType.image
		if let cell = self.tableView.cellForRow(at: indexPath) as? CategoryTableViewCell {
			mimeType = cell.mimeType
		}
		let action = UIContextualAction(style: .normal, title: "Remove") { [weak self] action, view, completion in
			completion(true)
			let media = self?.medias[indexPath.row]
			let index = self?.medias.firstIndex(where: {$0._id == media?._id})
			self?.medias.remove(at: index!)
			AppMusicFileManager.getInstance().removeFile(AppMusicFolder.resource, type: mimeType, name: media!.originalname, attributes: nil) { (success) in
				if success {
					RealmServices.getInstance().delete(media!)
				}
			}
			self?.tableView.beginUpdates()
			self?.tableView.deleteRows(at: [indexPath], with: .none)
			self?.tableView.endUpdates()
		}
		action.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
		return action
	}
	
	fileprivate func updateAction(_ indexPath: IndexPath) -> UIContextualAction {
		let media = self.medias[indexPath.row]
		let action = UIContextualAction(style: .normal, title: "Update") { (action, view, completion) in
			completion(true)
			self.configureAlertController(indexPath,with: media)
		}
		action.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
		return action
	}
	
	fileprivate func configureAlertController(_ indexPath: IndexPath,with media: MediaModel) {
		let alertController = UIAlertController(title: "Update", message: nil, preferredStyle: .alert)
		
		alertController.addTextField { (text) in
			text.placeholder = "file name..."
			text.text = media.name
		}
		alertController.addTextField { (text) in
			text.placeholder = "author..."
			text.text = media.author
		}
		
		let btnOk = UIAlertAction(title: "Ok", style: .default) { [weak self](action) in
			let dict:[String: Any?] = ["name":alertController.textFields?[0].text,"author": alertController.textFields?[1].text]
			RealmServices.getInstance().update(media, dict: dict)
			self?.tableView.beginUpdates()
			self?.tableView.reloadRows(at: [indexPath], with: .none)
			self?.tableView.endUpdates()
		}
		
		let btnCancel = UIAlertAction(title: "Cancel", style: .cancel)
		alertController.addAction(btnOk)
		alertController.addAction(btnCancel)
		
		self.present(alertController,animated: true)
	}
	
	
}

extension LocalController : AVPlayerViewControllerDelegate {
	
}
