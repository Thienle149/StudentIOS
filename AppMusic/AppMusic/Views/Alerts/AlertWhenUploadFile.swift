//
//  AlertWhenUploadFile.swift
//  AppMusic
//
//  Created by thienle on 3/27/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
import UIKit
protocol ALertWhenUploadFileProtocol {
	var timer:Int { get set}
	func start(status: AlertStatus, message: String? )
}
enum AlertStatus: String {
	case success = "Success"
	case failure = "Fail"
	
	func getImage() -> String {
		switch self {
		case .success:
			return "alert-success"
		case.failure:
			return "alert-fail"
		}
	}
}
class AlertWhenUploadFile: UIView, ALertWhenUploadFileProtocol {
	
	@IBOutlet var contentView: UIView!
	@IBOutlet weak var iconStatus: UIImageView!
	@IBOutlet weak var textStatus: UILabel!
	private let nidName: String = "AlertWhenUploadFile"
	open var timer: Int = 2
	
	private static var instance: AlertWhenUploadFile!
	
	public static func getInstance(_ parent: UIView) -> AlertWhenUploadFile{
		if instance == nil {
			instance = AlertWhenUploadFile(with: parent)
		}
		return instance
	}
	
	init(with parent: UIView,frame: CGRect = .zero) {
		super.init(frame: frame)
		parent.addSubview(self)
		UtilityFunc.configAutoLayout(parent: parent, child: self)
		self.configContentView()
		self.close(timer: timer)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	fileprivate func close(timer:Int) {
		UIView.animate(withDuration: TimeInterval(timer)) {
			self.alpha = 0
		}
		Timer.scheduledTimer(withTimeInterval: TimeInterval(timer), repeats: false) { (time) in
			self.removeFromSuperview()
			AlertWhenUploadFile.instance = nil
		}
	}
	
	fileprivate func configContentView() {
		Bundle.main.loadNibNamed(nidName, owner: self, options: nil)
		self.addSubview(contentView)
		UtilityFunc.configAutoLayout(parent: self, child: contentView)
	}
	
	
	func start(status: AlertStatus, message: String? = nil) {
		iconStatus.image = UIImage(named: status.getImage())
		textStatus.text = message ?? status.rawValue
	}
}
