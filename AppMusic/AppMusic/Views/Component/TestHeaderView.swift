//
//  TestHeaderView.swift
//  AppMusic
//
//  Created by thienle on 4/16/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class TestHeaderView: UIView {
	@IBOutlet weak var contentView: UIView!
	@IBOutlet weak var txtSubject: UITextField!
	@IBOutlet weak var txtNumSubject: UILabel!
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.configContentView()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.configContentView()
	}
	
	func setUp(number: Int, backgroundColor: UIColor?) {
		self.contentView.backgroundColor = backgroundColor
		txtNumSubject.text = "\(number)"
	}
	
	fileprivate func configContentView() {
		Bundle.main.loadNibNamed("TestHeaderView", owner: self, options: nil)
		self.addSubview(contentView)
		self.contentView.snp.makeConstraints { (make) in
			make.top.trailing.bottom.leading.equalToSuperview()
		}
	}
}
