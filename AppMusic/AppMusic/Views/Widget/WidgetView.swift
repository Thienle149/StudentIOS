//
//  WidgetView.swift
//  AppMusic
//
//  Created by thienle on 4/11/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import UIKit

class WidgetView: UIView {

	@IBOutlet weak var title: UILabel!
	@IBOutlet var container: UIStackView!
	@IBOutlet weak var contentView: UIView!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		Bundle.main.loadNibNamed("WidgetView", owner: self, options: nil)
		self.addSubview(container)
		container.snp.makeConstraints { (make) in
			make.top.trailing.bottom.leading.equalToSuperview()
		}
		
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		Bundle.main.loadNibNamed("WidgetView", owner: self, options: nil)
		container.snp.makeConstraints { (make) in
				make.top.trailing.bottom.leading.equalToSuperview()
			}
	}
	
	func setUp(title: String?,with view: UIView)
	{
		self.title.text = title
		self.contentView.addSubview(view)
		view.snp.makeConstraints { (make) in
			make.top.trailing.bottom.leading.equalToSuperview()
		}
	}
}
