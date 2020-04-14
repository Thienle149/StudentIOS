//
//  ViewController.swift
//  demostring
//
//  Created by thienle on 2/11/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import UIKit
// parrent = ["tar","ar","bus","us","abc"]
// =>result = [["tar","ar"],["bus","us"],["abc"]]
class ViewController: UIViewController {
	
	var arrParent: [String] = ["ar","tar","ar", "bus", "us", "abc"]
	var arrFilter = [Array<String>]()
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//// Thuật toán
		//Ý tưởng: Step1: Dựa vào phần tử đầu tiên để kiểm các phần tử còn lại có giống nó hay không. Nếu giống thì lưu mảng temp
		// Step: Update lại mảng gốc bằng cách: mảng gốc = mảng gốc - mảng temp (Mảng gốc chỉ còn những phần tử khác phần tử 1 VD(parrent = ["bar","us","abc"])). Thực hiện cho tới khi mảng gốc là Empty
		
		
		while true {
			if arrParent.isEmpty {
				break
			}
			var arrTemp:[String] = [arrParent[0]]
			for i in 1..<arrParent.count {
				//// [*] Quan trọng
				//Kiểm tra xem nó có chứa ([*]Dựa vào phần tử đầu)
				//"abc".contains("ab") thì ok. Nhưng nếu trường hợp phần tử đầu là "ab".contains("abc") thì sai. Do đó thực hiện kiểm tra ngược lại
				if arrParent[0].contains(arrParent[i]) || arrParent[i].contains(arrParent[0]) {
					arrTemp.append(arrParent[i])
				}
			}
			arrFilter.append(arrTemp)
			arrParent = subtractArray(subtrahend: arrParent, minus: arrTemp)
		}
		//// ----------- kết thúc thuật toán ------------
		

		//// Kết quả:
		print(arrFilter)
	}
	
	func subtractArray(subtrahend: [String], minus: [String]) -> [String] {
		return subtrahend.filter({
			return !minus.contains($0)
		})
	}
	
	
}

