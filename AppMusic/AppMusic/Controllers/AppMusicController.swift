//
//  AppMusicController.swift
//  AppMusic
//
//  Created by thienle on 4/10/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
import UIKit

protocol AppProperties {
	var textTitle: String { get set }
}
protocol AppMusicControllerProtocol {
	func addWidget(title: String?, with view: UIView)
	func addContentView(_ view: UIView)
}

class AppMusicController: UIViewController,AppMusicControllerProtocol,AppProperties {
	
	var textTitle: String = "" {
		didSet {
			self.appTitle.text = self.textTitle
		}
	}
	var refreshScrollView: UIRefreshControl?
	private var appTitle: UILabel!
	private var scrollView: UIScrollView!
	var contentView: UIStackView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = AppMusicConfig.backgroundColor
		
		configAppTitle()
		configScrollView()
		configContentView()
	}
	
	fileprivate func configAppTitle() {
		self.appTitle = UILabel()
		self.view.addSubview(appTitle)
		appTitle.snp.makeConstraints { (make) in
			make.top.equalToSuperview().offset(49)
			make.leading.equalToSuperview().offset(17)
			make.height.equalTo(49)
		}
		appTitle.font = UIFont(name: AppMusicConfig.font, size: 39)
		appTitle.text = textTitle
		appTitle.isUserInteractionEnabled = true
	}
	
	fileprivate func configScrollView() {
		self.scrollView = UIScrollView()
		self.refreshScrollView = UIRefreshControl()
		refreshScrollView?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
		self.scrollView.refreshControl = refreshScrollView
		self.scrollView.delegate = self
		self.view.addSubview(scrollView)
		self.scrollView.snp.makeConstraints { (make) in
			make.top.equalTo(appTitle.snp.bottom)
			make.trailing.bottom.leading.equalToSuperview()
		}
	}
	
	fileprivate func configContentView() {
		self.contentView = UIStackView()
		contentView.axis = .vertical
		contentView.spacing = 8
		self.scrollView.addSubview(contentView)
		self.contentView.snp.makeConstraints { (make) in
			make.top.trailing.bottom.leading.equalToSuperview()
			make.width.equalToSuperview()
			make.height.equalToSuperview().priority(250)
		}
	}
	
	@objc func refreshData() {
		self.refreshScrollView?.endRefreshing()
	}
	
	func addWidget(title: String?,with view: UIView) {
		let widget = WidgetView()
		widget.setUp(title: title, with: view)
		self.contentView.addArrangedSubview(widget)
	}
	
	func addContentView(_ view: UIView) {
		self.contentView.addSubview(view)
		view.snp.makeConstraints { (make) in
			make.top.leading.bottom.trailing.equalToSuperview()
		}
	}
}

extension AppMusicController: UIScrollViewDelegate {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		
	}
}
