//
//  ForYouController.swift
//  AppMusic
//
//  Created by thienle on 3/24/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
import UIKit
import SNCollectionViewLayout

class ForYouController: AppMusicController {
	
	var musicMixCollection: UICollectionView!
	var recentPlayedCollectionView: UICollectionView!
	
	let layout = SNCollectionViewLayout()
	var itemsMusicMix:[String] = ["poster1","poster2","poster3","poster4","poster1","poster2","poster3","poster4","poster1"]
	let itemsRecentPlayed:[RecentlyAddedModel] = [RecentlyAddedModel(pathImage: "poster1", song: "Nắng", singer: "MTP"),RecentlyAddedModel(pathImage: "poster2", song: "Ấm", singer: "Hà Hồ"),RecentlyAddedModel(pathImage: "poster3", song: "IT", singer: "IOS"),RecentlyAddedModel(pathImage: "poster4", song: "IOS", singer: "Swift")]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.textTitle = "For You"
		self.commonUI()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.commonData()
	}
	
	fileprivate func commonData() {
		layout.prepare()
	}
	
	fileprivate func commonUI(){
		configMusicMixCollection()
		configRecentPlayedCollectionView()
	}
	
	fileprivate func configMusicMixCollection() {
		/// Number Row
		layout.delegate = self
		layout.scrollDirection = .horizontal
		layout.fixedDivisionCount = 3
		layout.itemSpacing = 10
		
		self.musicMixCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
		self.addWidget(title: "", with: musicMixCollection)
		self.musicMixCollection.snp.makeConstraints { (make) in
//				make.top.equalToSuperview().offset(25)
//				make.trailing.leading.equalToSuperview().inset(20)
				make.height.equalTo(291)
			}
		self.musicMixCollection.dataSource = self
		self.musicMixCollection.delegate = self
		
		self.musicMixCollection.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 20)
		self.musicMixCollection.contentMode = .center
		let nibCell = UINib(nibName: ForYouCollectionViewCell.identifier, bundle: nil)
		self.musicMixCollection.register(nibCell, forCellWithReuseIdentifier: ForYouCollectionViewCell.identifier)
		
	}
	
	fileprivate func configRecentPlayedCollectionView() {
		let layout = UICollectionViewFlowLayout()
		layout.itemSize = CGSize(width: 157, height: 198)
		layout.scrollDirection = .horizontal
		self.recentPlayedCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		self.addWidget(title: "Recent Played", with: recentPlayedCollectionView)
		self.recentPlayedCollectionView.snp.makeConstraints { (make) in
			make.height.equalTo(198)
		}
		
		self.recentPlayedCollectionView.delegate = self
		self.recentPlayedCollectionView.dataSource = self
		
		let nibRecentlyAddedCollectonView = UINib(nibName: RecentlyAddedCollectionViewCell.identifier, bundle: nil)
		self.recentPlayedCollectionView.register(nibRecentlyAddedCollectonView, forCellWithReuseIdentifier: RecentlyAddedCollectionViewCell.identifier)
	}
}

extension ForYouController: UICollectionViewDataSource, UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if collectionView == musicMixCollection {
			return itemsMusicMix.count
		} else if collectionView == recentPlayedCollectionView{
			return itemsRecentPlayed.count
		}
		return 0
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if collectionView == musicMixCollection {
			if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForYouCollectionViewCell.identifier, for: indexPath) as? ForYouCollectionViewCell {
				cell.setUp(image: itemsMusicMix[indexPath.row])
				return cell
			}
		} else if collectionView == recentPlayedCollectionView {
			if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentlyAddedCollectionViewCell.identifier, for: indexPath) as? RecentlyAddedCollectionViewCell {
//				cell.setUp(itemsRecentPlayed[indexPath.row])
				return cell
			}
		}
		return UICollectionViewCell()
	}
}

extension ForYouController: SNCollectionViewLayoutDelegate {
	// scale for items based number of columns
	func scaleForItem(inCollectionView collectionView: UICollectionView, withLayout layout: UICollectionViewLayout, atIndexPath indexPath: IndexPath) -> UInt {
		if indexPath.row == 0 || indexPath.row == 6 {
			return 2
		}
		return 1
	}
	// height for item if set fixedDimension  height equal width
	func itemFlexibleDimension(inCollectionView collectionView: UICollectionView, withLayout layout: UICollectionViewLayout, fixedDimension: CGFloat) -> CGFloat {
		return fixedDimension
	}
	
	// header height
	func headerFlexibleDimension(inCollectionView collectionView: UICollectionView, withLayout layout: UICollectionViewLayout, fixedDimension: CGFloat) -> CGFloat {
		return 0
	}
}
