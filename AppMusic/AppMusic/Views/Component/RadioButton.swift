//
//  FERadioButton.swift
//  Form Engine
//
//  Created by thienle on 1/11/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class RadioButton: UIView {
	@IBOutlet var ContentView: UIStackView!
	@IBOutlet weak var label: UILabel!
	@IBOutlet weak var imageRadio: UIImageView!
	
	var mode: FERadioButtonType.mode = .one {
		didSet {
			imageRadio.image = UIImage(named: self.checked.getImage())?.filledImage(.orange)
		}
	}
	
	var checked: EventRadio = .unchecked {
		didSet {
			DispatchQueue.main.async {
				self.imageRadio.image = UIImage(named: self.checked.getImage())?.filledImage(.orange)			}
		}
	}
	
	private var lay = CAShapeLayer()
	
	var onClick: (()-> Void?)? = nil
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init(coder: NSCoder) {
		super.init(coder: coder)!
		commonInit()
	}
	
	fileprivate func commonInit() {
		Bundle.main.loadNibNamed("RadioButton", owner: self, options: nil)
		addSubview(ContentView)
		ContentView.translatesAutoresizingMaskIntoConstraints = false
		self.isUserInteractionEnabled = true
		ContentView.snp.makeConstraints({
			$0.trailing.equalToSuperview().offset(-10)
			$0.leading.equalToSuperview().offset(10)
			$0.top.bottom.equalToSuperview()
		})
		//Action
		let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
		ContentView.addGestureRecognizer(tap)
	}
	
	@objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
		checked == .checked ? checked = .unchecked : (checked = .checked)
		self.onClick?()
	}
	
	func setSelected(_ isCheck: EventRadio) {
		checked = isCheck
	}
	
	func setUp(text: String, mode: FERadioButtonType.mode) {
		self.label.text = text
		self.mode = mode
	}
}

enum FERadioButtonType {
	enum mode {
		case one
		case multiple
	}
}
