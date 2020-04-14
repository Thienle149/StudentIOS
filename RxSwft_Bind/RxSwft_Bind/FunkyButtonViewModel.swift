//
//  FunkyButtonViewModel.swift
//  RxSwft_Bind
//
//  Created by thienle on 2/13/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

protocol FunkyButtonProtocol {
	var backgroundColor: UIColor { get }
	var title: String { get }
	var funkyTapPublishSubject: PublishSubject<String> { get }
}

class FunkyButtonModelView: FunkyButtonProtocol {
	
	var backgroundColor: UIColor = .blue
	var title: String = ""
	var funkyTapPublishSubject: PublishSubject<String> = PublishSubject()
	
	init(title: String) {
		self.title = title
	}
}
