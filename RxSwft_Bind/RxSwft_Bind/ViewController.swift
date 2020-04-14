//
//  ViewController.swift
//  RxSwft_Bind
//
//  Created by thienle on 2/13/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

	@IBOutlet weak var stackViewContainer: UIStackView!
	@IBOutlet weak var lblButtonValue: UILabel!
	
	let viewModel = FunkyHomeViewModel()
	let disposeBag = DisposeBag()
	override func viewDidLoad() {
		super.viewDidLoad()
		
		viewModel.items.forEach { (funkyViewModel) in
			let funkyButton = FunkyButton(viewModel: funkyViewModel)
			stackViewContainer.addArrangedSubview(funkyButton)
		}
		
		let funkyPublishObservableArray = viewModel.items.map({
			$0.funkyTapPublishSubject
		})
		
		Observable.merge(funkyPublishObservableArray)
			.map({ "Number: \($0.uppercased())" })
			.bind(to: lblButtonValue.rx.text)
			.disposed(by: disposeBag)
	}
}

