//
//  AlertLoadingView.swift
//  AppMusic
//
//  Created by thienle on 4/21/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
import UIKit

class AlertLoadingView: UIView {
	
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet var contentView: UIView!
	
	
	private static var instance: AlertLoadingView!
	
	public static func getInstance(_ parent: UIView) -> AlertLoadingView {
		if instance == nil {
			instance = AlertLoadingView(parent: parent)
		}
		return instance
	}
	
	init(parent: UIView) {
		super.init(frame: .zero)
		parent.addSubview(self)
		self.snp.makeConstraints({
			$0.top.leading.bottom.trailing.equalToSuperview()
		})
		
		Bundle.main.loadNibNamed("AlertLoadingView", owner: self, options: nil)
		self.addSubview(contentView)
		contentView.snp.makeConstraints({
			$0.top.trailing.bottom.leading.equalToSuperview()
		})
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func start() {
		let images = ["loading1","loading2"]
		let image = UIImage.gif(asset: images[Int.random(in: 0..<images.count)])
		imageView.image = image
	}
	
	func stop() {
		imageView.image = nil
		AlertLoadingView.instance.removeFromSuperview()
		AlertLoadingView.instance = nil
	}
	
}
