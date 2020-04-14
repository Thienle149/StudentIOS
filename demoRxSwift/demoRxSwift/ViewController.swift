//
//  ViewController.swift
//  demoRxSwift
//
//  Created by thienle on 2/12/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

class ViewController: UIViewController {
	
	@IBOutlet weak var txtInstruction: UILabel!
	var disposeBag = DisposeBag()
	
	let vcDetail = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "DetailController") as! DetailController
	
	override func viewDidLoad() {
		super.viewDidLoad()
		txtInstruction.text = "Hello"
	}
	
	@IBAction func navigateDetail(_ sender: Any) {
		vcDetail.selectedCharacter.subscribe(onNext: { [weak self] character in
			self?.txtInstruction.text = "Hello \(character)"
			}).disposed(by: disposeBag)
		self.navigationController?.pushViewController(vcDetail, animated: true)
	}
}


