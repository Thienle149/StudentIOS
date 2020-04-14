//
//  ViewController.swift
//  GCD_KhoaPham1
//
//  Created by thienle on 2/1/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		testGCD()
	}
	
	
	func testGCD() {
		// Default Blocking FIFO
		//Buoc 1: Tạo luồng mới
		let queue = DispatchQueue(label: "queue")
		// Buoc 2: Đưa code vào block async
		queue.async {
			for i in 0...100 {
				print("i:\(i)")
			}
		}
		for i in 0...100 {
			print("k:\(i)")
		}
	}
}

