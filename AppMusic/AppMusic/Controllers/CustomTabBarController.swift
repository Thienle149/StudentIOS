//
//  CustomTabBarController.swift
//  AppMusic
//
//  Created by thienle on 4/9/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
import UIKit
class CutomTabBarController: UITabBarController {
	
	private let imagesAsset = ["tabbar-libary","tabbar-foryou","tabbar-questionanswer","tabbar-local","tabbar-upload"]
	private let titles = ["Libary","For You","Kiểm tra","Local","Upload"]
	lazy var appController = AppController()
	lazy var forYouController = ForYouController()
	lazy var localController = LocalController()
	var uploadController =  UploadController()
	lazy var  questionAnswerControleller = QuestionAnswerController()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.configureTabBar()
	}
	
	func configureTabBar() {
		
		self.tabBar.barTintColor = .black
		self.tabBar.isTranslucent = true
		viewControllers = [appController,forYouController,questionAnswerControleller,localController,uploadController]
		customizableViewControllers = [appController,forYouController,questionAnswerControleller,localController,uploadController]
		UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)], for: .selected)
		UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)], for: .normal)
		
		let size = CGSize(width: 16, height: 16)
		for index in 0..<imagesAsset.count {
			setUpItems(imageSelect: UIImage(named:imagesAsset[index]), imageDeselect: UIImage(named:imagesAsset[index]), size: size, index: index)
		}
		//
		NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: .main) { (notification) in
			let numberOfTabs = CGFloat((self.tabBar.items?.count)!)
			let tabBarSize = CGSize(width: self.tabBar.frame.width / numberOfTabs, height: self.tabBar.frame.height)
			self.tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), size: tabBarSize)
			}
		
		self.selectedIndex = 0
	}
	
	fileprivate func setUpItems(imageSelect: UIImage?, imageDeselect: UIImage?, size: CGSize?, index: Int) {
		let tabBar = UITabBarItem()
		tabBar.title = titles[index]
		tabBar.image = imageSelect?.scaleImage(toSize: CGSize(width: 16, height: 16))?.withRenderingMode(.alwaysOriginal)
		tabBar.selectedImage = imageDeselect?.withRenderingMode(.alwaysOriginal)
		viewControllers?[index].tabBarItem = tabBar
		
	}
}
