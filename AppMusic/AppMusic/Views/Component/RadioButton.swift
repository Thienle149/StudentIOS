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
	var color: UIColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1) {
		didSet{
			imageRadio.image = UIImage(named: self.checked.getImage())?.filledImage(color)
		}
	}
	
	var mode: FERadioButtonType.mode = .one {
		didSet {
			imageRadio.image = UIImage(named: self.checked.getImage())?.filledImage(color)
		}
	}
	
	var checked: EventRadio = .unchecked {
		didSet {
			DispatchQueue.main.async {
				self.imageRadio.image = UIImage(named: self.checked.getImage())?.filledImage(self.color)			}
		}
	}
	
	private var lay = CAShapeLayer()
	
	var onClick: ((RadioButton)-> Void?)? = nil
	
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
		self.onClick?(self)
	}
	
	func setSelected(_ isCheck: EventRadio) {
		checked = isCheck
	}
	
	func setUp(text: String?, mode: FERadioButtonType.mode,color: UIColor =  #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)) {
		self.label.text = text ?? ""
		self.mode = mode
		self.color = color
	}
}

enum FERadioButtonType {
	enum mode {
		case one
		case multiple
	}
}
