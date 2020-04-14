//
//  ViewController.swift
//  Observer_1
//
//  Created by thienle on 2/6/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var view1: UIView!
	@IBOutlet weak var view2: UIView!
	@IBOutlet weak var testShow: UILabel!
	@IBOutlet weak var testField: UITextField!
	override func viewDidLoad() {
		super.viewDidLoad()
		testField.delegate = self
		testField.addTarget(self, action: #selector(listenText), for: .editingChanged)
		testShow.addObserver(self, forKeyPath: "text", options: .prior, context: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(textNotification(_:)), name: NSNotification.Name("textDemo"), object: nil)
		view1.addObserver(self, forKeyPath: "backgroundColor", options: .prior, context: nil)
	}
	
	@objc func textNotification(_ notification: Notification) {
		let textField = notification.object as! UITextField
		testShow.text = textField.text
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
//		view1.addObserver(self, forKeyPath: "backgroundColor", options: .old, context: nil)
	}
	
	@IBAction func btnColor(_ sender: Any) {
		view1.backgroundColor = .red
	}
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if keyPath == "backgroundColor" {
		view2.backgroundColor = view1.backgroundColor
		}
	}
//	deinit {
//		testField.removeObserver(self, forKeyPath: "text")
//	}
}

extension ViewController: UITextFieldDelegate{
	@objc func listenText() {
		NotificationCenter.default.post(name: NSNotification.Name("textDemo"), object: testField)
	}
}

