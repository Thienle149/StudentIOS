//
//  FunkyButton.swift
//  RxSwft_Bind
//
//  Created by thienle on 2/13/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class FunkyButton: UIButton {
	
	var viewModel: FunkyButtonProtocol!
	var disposeBag = DisposeBag()
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	required init(viewModel: FunkyButtonProtocol) {
		self.viewModel = viewModel
		super.init(frame: .zero)
		
		self.backgroundColor = viewModel.backgroundColor
		self.setTitle("\(viewModel.title)", for: .normal)
		self.rx.tap
			.bind{
			self.viewModel.funkyTapPublishSubject.onNext(self.viewModel.title)
				print("Funky button with title \(self.viewModel.title) is tapped!")
		}.disposed(by: disposeBag)
	}
}
