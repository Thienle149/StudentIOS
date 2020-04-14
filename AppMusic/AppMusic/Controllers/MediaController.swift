//
//  MediaController.swift
//  AppMusic
//
//  Created by thienle on 4/1/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
import UIKit

class MediaController: UIViewController {
	
	@IBOutlet weak var imageMedia: CustomImageView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		self.imageMedia.image = nil
	}
	@IBAction func back(_ sender: Any) {
		dismiss(animated: true) {
			
		}
	}
}
