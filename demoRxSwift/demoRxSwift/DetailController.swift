//
//  DetailController.swift
//  demoRxSwift
//
//  Created by thienle on 2/12/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay
//// Dùng Observer trong RxSwift thay cho Delegate Pattern

//protocol delegateDetail {
//	func introduce(animal: String)
//}

class DetailController: UIViewController {
	
//	var delegate: delegateDetail!
	
	private let selectedCharacterVarible = BehaviorRelay<String>(value: "User")
	var selectedCharacter: Observable<String> {
		return selectedCharacterVarible.asObservable()
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }

	@IBAction func touchChicken(_ sender: Any) {
		selectedCharacterVarible.accept("Chicken")
	}
	
	@IBAction func touchBuffallo(_ sender: Any) {
		selectedCharacterVarible.accept("Buffallo")
	}
	
	@IBAction func touchBear(_ sender: Any) {
		selectedCharacterVarible.accept("Bear")
	}
}
