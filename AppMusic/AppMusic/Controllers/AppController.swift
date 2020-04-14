//
//  ViewController.swift
//  AppMusic
//
//  Created by thienle on 3/21/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import SocketIO
protocol FetchDataForTable {
	associatedtype cellModel
	var itemsTable: [cellModel]{get set}
	func fectchData(completion: @escaping () -> Void)
}
class AppController: AppMusicController,FetchDataForTable {
	
	typealias cellModel = CategoryCellModel
	
	typealias completionNonParameter = () -> Void
	var section: Int?
	var limit = 10
	lazy var loadingView = UIActivityIndicatorView()
	var tableCategory: UITableView!
	var recentAddedCollectonView: UICollectionView!
	var heightAnchorTableViewCategory: NSLayoutConstraint!
	var networkServices = NetworkServices()
	var heightAnchorTabBar: NSLayoutConstraint!
	var itemsTable: [CategoryCellModel] = []
	
	var recentlyAddeds:[MediaModel] = []
	var imageController: MediaController!
	lazy var videoController: AVPlayerViewController = AVPlayerViewController()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.textTitle = "Libary"
		self.commonUI()
		self.commonData()
	}
	
	fileprivate func  commonUI() {
		
		self.imageController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MediaController") as? MediaController
		self.configTableCategory()
		self.configRecentlyAddedCollectionView()
	}
	
	override func refreshData() {
		super.refreshData()
		self.commonData()
	}
	
	fileprivate func commonData() {
		self.itemsTable = []
		self.getDataOfitemsTable {
			self.tableCategory.reloadData()
		}
		
		self.getDataRecentAdded {
			self.recentAddedCollectonView.reloadData()
		}
		self.observeDataOfTableCategoryFromSocketServer()
		RealmServices.getInstance().observeRealmError { (err) in
			if let error = err {
				print("###Realm Error \(error)")
			}
		}
	}
	
	@objc func touchEdit() {
		print("###touch edit")
	}
	
	fileprivate func configTableCategory() {
		tableCategory = UITableView()
		self.addWidget(title: nil, with: tableCategory)
		
		heightAnchorTableViewCategory = tableCategory.heightAnchor.constraint(equalToConstant: 201)
		heightAnchorTableViewCategory.isActive = true
		
		tableCategory.dataSource = self
		tableCategory.delegate = self
		
		tableCategory.addObserver(self, forKeyPath: "contentSize", options: .old, context: .none)
		
		let nibCategorySessionCell = UINib(nibName: CategorySessionTableViewCell.identifier, bundle: nil)
		let nibCategoryCell = UINib(nibName: CategoryTableViewCell.identifier, bundle: nil)
		
		tableCategory.register(nibCategorySessionCell, forCellReuseIdentifier: CategorySessionTableViewCell.identifier)
		tableCategory.register(nibCategoryCell, forCellReuseIdentifier: CategoryTableViewCell.identifier)
	}
	
	fileprivate func configRecentlyAddedCollectionView() {
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.scrollDirection = .horizontal
		flowLayout.itemSize = CGSize(width: 157, height: 198)
		self.recentAddedCollectonView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
		self.recentAddedCollectonView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
		self.recentAddedCollectonView.showsVerticalScrollIndicator = false
		self.recentAddedCollectonView.showsHorizontalScrollIndicator = false
		self.addWidget(title: "Recently Added ", with: recentAddedCollectonView)
		self.recentAddedCollectonView.snp.makeConstraints { (make) in
			make.height.equalTo(198)
		}
		
		self.recentAddedCollectonView.dataSource = self
		self.recentAddedCollectonView.delegate = self
		
		let nibRecentlyAddedCollectonView = UINib(nibName: RecentlyAddedCollectionViewCell.identifier, bundle: nil)
		self.recentAddedCollectonView.register(nibRecentlyAddedCollectonView, forCellWithReuseIdentifier: RecentlyAddedCollectionViewCell.identifier)
		
	}
	
	fileprivate func getDataOfitemsTable(_ completion: @escaping completionNonParameter) {
		NetworkServices.getInstance().getData(route: "/categories/medias/\("?")limit=\(limit)") { (dictitemsTable, err) in
			if err == nil {
				if let dictitemsTable = dictitemsTable {
					for dictCategoryCell in dictitemsTable {
						self.itemsTable.append(CategoryCellModel(dictCategoryCell))
					}
				}
				DispatchQueue.main.async {
					completion()
				}
			} else {
				print(err ?? "")
			}
		}
	}
	
	fileprivate func getDataRecentAdded(_ completion: @escaping completionNonParameter) {
		NetworkServices.getInstance().getData(route: "/medias/recent") { (dictMedias, err) in
			if err == nil {
				if let dictMedias = dictMedias {
					for dictMedia in dictMedias {
						self.recentlyAddeds.append(MediaModel(dictMedia))
					}
					DispatchQueue.main.async {
						completion()
					}
				}
			}
		}
	}
	
	@objc fileprivate func refreshData(_ sender: UIRefreshControl) {
		
	}
	
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if let obj = object as? UITableView,obj == tableCategory {
			DispatchQueue.main.async {
				self.heightAnchorTableViewCategory.constant = self.tableCategory.contentSize.height
			}
		}
	}
	
	fileprivate func observeDataOfTableCategoryFromSocketServer() {
		NotificationCenter.default.addObserver(forName: Notification.Name(SocketEventName.on.media.rawValue), object: nil, queue: .none) { (notification) in
			if let dictMedia = notification.object as? [String: Any?] {
				let media = MediaModel(dictMedia)
				let section = self.itemsTable.firstIndex { (item) -> Bool in
					return item.category._id == media.categoryID
				}
				self.itemsTable[section!].contentRow.append(media)
				
				if self.itemsTable[section!].open {
					let row = self.itemsTable[section!].contentRow.endIndex
					self.tableCategory.beginUpdates()
					self.tableCategory.insertRows(at: [IndexPath(row: row, section: section!)], with: .none)
					self.tableCategory.endUpdates()
				}
			}
		}
	}
	
	deinit {
		RealmServices.getInstance().stopObservingError(in: self)
		self.tableCategory.removeObserver(self, forKeyPath: "contentSize")
	}
}

extension AppController: UITableViewDataSource, UITableViewDelegate {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return itemsTable.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if itemsTable[section].open {
			return itemsTable[section].contentRow.count + 1
		}
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		tableView.sectionFooterHeight = 50
		if indexPath.row == 0 {
			if let cell = tableView.dequeueReusableCell(withIdentifier: CategorySessionTableViewCell.identifier, for: indexPath) as? CategorySessionTableViewCell {
				cell.setUp(name: itemsTable[indexPath.section].category.name)
				return cell
			}
		}else {
			if let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as? CategoryTableViewCell {
				let objMedia = itemsTable[indexPath.section].contentRow[indexPath.row - 1]
				cell.setUp(media: objMedia, index: indexPath,type: .server)
				cell.delegateDownload = self
				return cell
			}
		}
		return CategorySessionTableViewCell()
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		section = indexPath.section
		if indexPath.row == 0 {
			if itemsTable[indexPath.section].open == true{
				itemsTable[indexPath.section].open = false
				self.section = nil
			} else {
				itemsTable[indexPath.section].open = true
			}
			DispatchQueue.main.async {
				tableView.reloadSections(IndexSet(integer: indexPath.section), with: .none)
			}
		}
		else {
			let objMedia = itemsTable[indexPath.section].contentRow[indexPath.row - 1]
			if let cell = tableView.cellForRow(at: indexPath) as? CategoryTableViewCell {
				self.loadMediaController(cell: cell,media: objMedia, with: indexPath)
			}
		}
	}
	
	
//	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//		let view = UIView()
//		view.backgroundColor = .red
//		view.addSubview(loadingView)
//		loadingView.startAnimating()
//		loadingView.snp.makeConstraints { (make) in
//			make.centerX.centerY.equalToSuperview()
//			make.height.width.equalTo(25)
//		}
//		return view
//	}
//
//	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
////		if itemsTable[section].isFetch == .accept {
//			return 50
////		}
////		return 0
//	}
	
	fileprivate func loadMediaController(cell: CategoryTableViewCell, media: MediaModel, with indexPath: IndexPath) {
		if cell.mimeType == .video {
			if let path = media.path, let url = URL(string: "\(NetworkServices.hostname)/\(path)") {
				let videoPlayer = AVPlayer(url: url)
				videoController.player = videoPlayer
				videoController.delegate = self
				self.present(videoController,animated: true,completion: {
					videoPlayer.play()
				})
			}
		} else {
			self.present(imageController,animated: true,completion: {
				self.imageController.imageMedia.LoadImageFromURL(with:"\(NetworkServices.hostname)/\(media.path!)" , identifier: "\(indexPath)")
			})
		}
	}
	
	override func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if let section = section {
			let offsetY = scrollView.contentOffset.y
			let frameCategory = tableCategory.rect(forSection: section)
			if offsetY > frameCategory.height + frameCategory.origin.y - scrollView.frame.height {
				if itemsTable[section].isFetch == .disaccept
				{
//					tableCategory.beginUpdates()
					itemsTable[section].isFetch = .accept
							let view = UIView()
							view.backgroundColor = .red
							view.addSubview(loadingView)
							loadingView.startAnimating()
							loadingView.snp.makeConstraints { (make) in
								make.centerX.centerY.equalToSuperview()
								make.height.width.equalTo(25)
							}
//					tableCategory.reloadSections(IndexSet(integer: section), with: .none)
//					tableCategory.endUpdates()
					self.fectchData {
//						self.tableCategory.beginUpdates()
						if self.itemsTable[section].isFetch != .complete {
							self.itemsTable[section].isFetch = .disaccept
						}
						
//						self.tableCategory.endUpdates()
					}
				}
			}
		}
	}
	
	func fectchData(completion: @escaping () -> Void) {
		let offset = itemsTable[section!].contentRow.count
		let limit = self.limit + itemsTable[section!].contentRow.count
		let id = itemsTable[section!].category._id
		NetworkServices.getInstance().getData(route: "/categories/id/\(id!)/?offset=\(offset)&limit=\(limit)") { (dictMedias, err) in
			if err == nil {
				if let dictMedias = dictMedias {
					var medias: [MediaModel] = []
					for dictMedia in dictMedias {
						medias.append(MediaModel(dictMedia))
						self.tableCategory.beginUpdates()
						self.itemsTable[self.section!].contentRow.append(MediaModel(dictMedia))
						let row = 	self.itemsTable[self.section!].contentRow.count
						self.tableCategory.insertRows(at: [IndexPath(row: row, section: self.section!)], with: .none)
						self.tableCategory.endUpdates()
					}
					if medias.count == 0 {
						self.itemsTable[self.section!].isFetch = .complete
					}
//					else {
//						self.itemsTable[self.section!].contentRow.append(contentsOf: medias)
//					}
					
							completion()
				}
			} else {
				
			}
		}
	}
}

extension AppController: ActionDownloadCategoryTableViewCell {
	func save(indexPath: IndexPath, mimeType: MimeType) {
		self.saveDataLocal(indexPath: indexPath) { (success) in
			if success {
				self.saveImageLocal(indexPath: indexPath, mimeType: mimeType){ (success) in
					self.alertWhenDownloadComplete(status: success)
				}
			} else  {
				self.alertWhenDownloadComplete(status:success)
			}
		}
	}
	
	func showButtonDownload() -> Bool {
		true
	}
	
	fileprivate func alertWhenDownloadComplete(status: Bool) {
		if status {
			AlertWhenUploadFile.getInstance(self.view).start(status: .success)
		} else {
			AlertWhenUploadFile.getInstance(self.view).start(status: .failure,message: "File đã tồn tại!")
		}
	}
	
	fileprivate func saveImageLocal(indexPath: IndexPath, mimeType: MimeType, _ completion: @escaping (Bool) -> Void) {
		let objMedia = itemsTable[indexPath.section].contentRow[indexPath.row - 1]
		if let path = objMedia.path, let url = URL(string: "\(NetworkServices.hostname)/\(path)"), let data = NSData(contentsOf: url) {
			AppMusicFileManager.getInstance().importFile(.resource,type: mimeType, name: objMedia.originalname, content: data as Data, attributes: nil) { (success) in
				completion(success)
			}
		}
	}
	
	fileprivate func saveDataLocal(indexPath: IndexPath,_ completion: @escaping (Bool) -> Void) {
		
		let objMedia = itemsTable[indexPath.section].contentRow[indexPath.row - 1]
		let medias = RealmServices.getInstance().realm.objects(MediaModel.self)
		let contains = medias.contains { (item) -> Bool in
			return item._id == objMedia._id
		}
		if !contains {
			RealmServices.getInstance().create(objMedia)
			NotificationCenter.default.post(name: Notification.Name("NotifyMedias"), object: objMedia)
			completion(true)
		} else {
			completion(false)
		}
	}
	
}

extension AppController: UICollectionViewDataSource, UICollectionViewDelegate{
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return recentlyAddeds.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentlyAddedCollectionViewCell.identifier, for: indexPath) as? RecentlyAddedCollectionViewCell {
			cell.setUp(recentlyAddeds[indexPath.row])
			return cell
		}
		return RecentlyAddedCollectionViewCell()
	}
}

extension AppController: AVPlayerViewControllerDelegate{
	
}
