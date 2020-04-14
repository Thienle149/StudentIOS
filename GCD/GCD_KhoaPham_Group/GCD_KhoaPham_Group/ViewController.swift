//
//  ViewController.swift
//  GCD_KhoaPham_Group
//
//  Created by thienle on 2/1/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		testCGDCGroup()
	}


	func testCGDCGroup() {
		//Buoc 1: Tao luong mới
		let queue = DispatchQueue(label: "queue")
		//Bước 2: Đưa code vào block async
		
		//Tao group ->
		//Ý nghĩa: Có thể biết được tác vụ chạy tới khi nào hoàn tất (Hoặc có thể biết được công việc này hoàn tất có đúng theo thời gian quy đinh hay không? )
		//-Result : success or timeOut
		//- Ứng dụng : Có thể dùng để load ảnh từ trên mạng về nếu load đúng thời gian quy đinh thì hiển thị. Còn không đúng thời gian thì hiện thị thông báo
		
		let group = DispatchGroup()
		// Trước khi chạy async thì cho group bắt đầu chay
		group.enter()
		queue.async {
			for i in 0...1000000 {
				print("i: \(i)")
			}
			//Hoàn tất thì ngừng chạy bộ đếm giờ
			group.leave()
		}
		// Thời gian quy định 3s
		let result = group.wait(timeout: DispatchTime.now() + 3)
		print(result)
	}
}

