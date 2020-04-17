//
//  UploadController.swift
//  AppMusic
//
//  Created by thienle on 4/15/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
import UIKit
class UploadController: AppMusicController {
	
	var collectionUploadView: UICollectionView!
	var items:[UploadModel]!
	override func viewDidLoad() {
		super.viewDidLoad()
		let storyborad = UIStoryboard.init(name: "Main", bundle: nil)
		
		let uploadFromServerVC = storyborad.instantiateViewController(withIdentifier: "UploadServerController") as? UploadServerController
		
		let uploadExerciseVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UploadExerciseController") as? UploadExerciseController
		
		self.items = [UploadModel(title: "Exercise", image: "upload-exercise", controller: uploadExerciseVC),UploadModel(title: "Media", image: "upload-media",controller: uploadFromServerVC)]
		self.textTitle = "Upload"
		self.configCollectionUploadView()
	}
	
	 func configCollectionUploadView() {
		
		let layout = UICollectionViewFlowLayout()
		layout.itemSize = CGSize(width: 96, height: 96)
		layout.scrollDirection = .vertical
		
		collectionUploadView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionUploadView.backgroundColor = AppMusicConfig.backgroundColor
		self.addContentView(collectionUploadView)
		
		collectionUploadView.dataSource = self
		collectionUploadView.delegate = self
		
		let nib = UINib(nibName: UploadCollectionViewCell.identifier, bundle: nil)
		collectionUploadView.register(nib, forCellWithReuseIdentifier: UploadCollectionViewCell.identifier)
	}
}

extension UploadController: UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return items.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UploadCollectionViewCell.identifier, for: indexPath) as? UploadCollectionViewCell {
			cell.setUp(imageName: items[indexPath.row].image, title: items[indexPath.row].title)
			return cell
		}
		return UICollectionViewCell()
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if let controller = items[indexPath.row].controller {
		self.present(controller,animated: true)
		}
	}
}
