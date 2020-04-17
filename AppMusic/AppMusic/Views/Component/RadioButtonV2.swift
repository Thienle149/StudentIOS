//
//  RadioButtonV2.swift
//  AppMusic
//
//  Created by thienle on 4/16/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
import UIKit
enum EventRadio {
	
	
	case checked 
	case unchecked
	
	func getImage() -> String {
		if self == .checked {
			return "radio-check"
		}
		return "radio-uncheck"
	}
}
class RadioButtonV2: UIView {
	
	@IBOutlet var contentView: UIStackView!
	@IBOutlet weak var radioImage: UIImageView!
	
	var onClick: ((RadioButtonV2)->Void?)? = nil
	var check: EventRadio = .unchecked {
		didSet {
			DispatchQueue.main.async {
				self.radioImage.image = UIImage(named: self.check.getImage())
			}
		}
	}
	
	init() {
		super.init(frame: .zero)
		self.configContentView()
		self.configRadioImage()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.configContentView()
		self.configRadioImage()
	}
	
	fileprivate func configRadioImage() {
		let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandle))
		self.radioImage.addGestureRecognizer(tap)
		self.radioImage.isUserInteractionEnabled = true
	}
	
	@objc func tapHandle() {
		check == .checked ? check = .unchecked : (check = .checked)
		self.onClick?(self)
	}
	
	fileprivate func configContentView() {
		Bundle.main.loadNibNamed("RadioButtonV2", owner: self, options: nil)
		self.addSubview(contentView)
		self.contentView.snp.makeConstraints { (make) in	make.top.trailing.bottom.leading.equalToSuperview()
		}
	}
}
