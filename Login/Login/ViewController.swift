//
//  ViewController.swift
//  Login
//
//  Created by thienle on 2/7/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var txtUsername: UITextField!
	@IBOutlet weak var txtPassword: UITextField!
	@IBOutlet weak var btnLogin: UIButton!
	var vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailUserController") as? DetailUserController
	override func viewDidLoad() {
		super.viewDidLoad()
	}

	@IBAction func handler(_ sender: Any) {
//		self.present(vc!, animated: true, completion: nil)
		self.navigationController?.pushViewController(vc!, animated: true)
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		configurePassword()
	}
	
	func configurePassword() {
		txtPassword.isSecureTextEntry = true
	}

}

