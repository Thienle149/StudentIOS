//
//  UploadServerController.swift
//  AppMusic
//
//  Created by thienle on 3/25/20.
//  Copyright © 2020 thienle. All rights reserved.
//

import Foundation
import Alamofire
import AVKit
import UIKit
import RxSwift
import RxCocoa


class UploadServerController: UIViewController {
	
	typealias completionNonParmater = () -> Void
	@IBOutlet weak var btnRemoveImage: UIImageView!
	@IBOutlet weak var widthBtnRemoveImage: NSLayoutConstraint!
	@IBOutlet weak var backgroundUpload: UIView!
	@IBOutlet weak var contentView: UIView!
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var progressDownLoad: UIProgressView!
	@IBOutlet weak var thumnailmage: UIView!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var txtName: UITextField!
	@IBOutlet weak var txtAuthor: UITextField!
	@IBOutlet weak var txtAlbum: UITextField!
	@IBOutlet weak var widthImageView: NSLayoutConstraint!
	@IBOutlet weak var btnImportToServer: UIButton!
	
	//Properties Observer
	private var urlOfFile = BehaviorRelay<URL?>(value: nil)
	private var idOfCategories = BehaviorRelay<String?>(value: nil)
	
	private let bag = DisposeBag()
	var dropDownView: DropDownView?
	var itemsCategory:[CategoryModel] = []
	var tapScreen: UITapGestureRecognizer!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.commonUI()
		self.commonData()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.cancelClearImage()
	}
	
	fileprivate func commonUI() {
		self.bindUI()
		self.handleKeyboardTouchScreen()
		self.handleTouchThumbnailImage()
		self.configBtnRemoveImage()
		self.configProgressDownload()
		self.configTextField()
		self.configDropDownView()
	}
	
	@IBAction func backUploadController(_ sender: Any) {
		self.dismiss(animated: true) {
		}
	}
	
	fileprivate func configBtnRemoveImage() {
		self.widthBtnRemoveImage.constant = 0
		let width = self.btnRemoveImage.frame.width
		self.btnRemoveImage.layer.cornerRadius = width / 2
		self.btnRemoveImage.isUserInteractionEnabled = true
		let tap = UITapGestureRecognizer(target: self, action: #selector(clearImage(_:)))
		self.btnRemoveImage.addGestureRecognizer(tap)
	}
	 
	fileprivate func configProgressDownload() {
		self.progressDownLoad.isHidden = true
		self.backgroundUpload.layer.borderWidth = 1
		self.backgroundUpload.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
		self.backgroundUpload.layer.cornerRadius = 5
	}
	
	fileprivate func configTextField() {
		self.txtName.delegate = self
		self.txtAlbum.delegate = self
		self.txtAuthor.delegate = self
		
		let tapAlb = UITapGestureRecognizer(target: self, action: #selector(tapAlbum(_:)))
		txtAlbum.addGestureRecognizer(tapAlb)
	}
	
	fileprivate func configDropDownView() {
		self.dropDownView = DropDownView(with: self.view,title: "Category", items: itemsCategory)
		self.dropDownView?.delegate = self
	}
	
	@objc func tapAlbum(_ sender: UITapGestureRecognizer) {
		dropDownView?.open()
		tapScreen.isEnabled = false
	}
	
	fileprivate func bindUI() {
		Observable.combineLatest(txtName.rx.text, txtAuthor.rx.text,idOfCategories.asObservable(),urlOfFile.asObservable(), resultSelector: {
			txtName,txtAuthor,id,url in
			return self.isEnbleOfBtnImportToServer(name: txtName, author: txtAuthor,id: id, url: url)
		}).bind(to: btnImportToServer.rx.isEnabled)
			.disposed(by: bag)
	}
	
	fileprivate func isEnbleOfBtnImportToServer(name: String?, author: String?,id: String?, url: URL?) -> Bool {
		if let name = name, let author = author, let _ = id, let _ = url, name.count > 0 && author.count > 0{
			return true
		}
		return false
	}
	
	fileprivate func handleKeyboardTouchScreen() {
		self.tapScreen = UITapGestureRecognizer(target: self, action: #selector(handleTapScreen))
		self.view.addGestureRecognizer(tapScreen)
		HandleKeyboardWShowHide.getInstance().addObserver(completion: adjustForKeyboard(notification:))
	}
	
	@objc func handleTapScreen() {
		self.view.endEditing(true)
		self.cancelClearImage()
	}
	
	fileprivate func adjustForKeyboard(notification: Notification) {
		guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
		
		let keyboardScreenEndFrame = keyboardValue.cgRectValue
		let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
		
		if notification.name == UIResponder.keyboardWillHideNotification {
			self.scrollView.contentInset = .init(top: 0, left: 0, bottom: -view.safeAreaInsets.bottom, right: 0)
		} else {
			self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
		}
		
		self.scrollView.scrollIndicatorInsets = scrollView.contentInset
	}
	
	fileprivate func handleTouchThumbnailImage() {
		let tap = UITapGestureRecognizer(target: self, action: #selector(importImage(_:)))
		let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressImage(_:)))
		self.thumnailmage.addGestureRecognizer(longPress)
		self.thumnailmage.addGestureRecognizer(tap)
	}
	
	fileprivate func commonData() {
		getDataOfCategory {
			self.afterCompleteGetDataCategory()
		}
	}
	
	fileprivate func getDataOfCategory(completion: @escaping completionNonParmater) {
		NetworkServices.getInstance().getData(route: "/categories") { (dicts, err) in
			if err == nil {
				if let items = dicts {
					for item in items {
						let category = CategoryModel(item)
						self.itemsCategory.append(category)
					}
					completion()
				}
			} else {
				print(err)
			}
		}
	}
	
	fileprivate func afterCompleteGetDataCategory() {
		self.dropDownView?.items = itemsCategory
	}
	
	@objc func importImage(_ sender: UIPanGestureRecognizer) {
		UIView.animate(withDuration: TimeInterval(0.05), animations: {
			if self.urlOfFile.value == nil {
				self.imageView.alpha = 0.25
				self.widthImageView.constant = 50
			}
		}) { (value) in
			print("###\(value)")
			let documentPicker = UIImagePickerController()
			documentPicker.delegate = self
			documentPicker.allowsEditing = true
			documentPicker.mediaTypes = ["public.image", "public.movie"]
			documentPicker.sourceType = .photoLibrary
			self.present(documentPicker, animated: true,completion: {
				if self.urlOfFile.value == nil {
					self.imageView.alpha = 1
					self.widthImageView.constant = 48
				}
			})
		}
	}
	
	@objc func longPressImage(_ sender: UILongPressGestureRecognizer) {
		if sender.state == .began {
			if urlOfFile.value != nil {
				self.widthBtnRemoveImage.constant = 24
				self.imageView.alpha = 0.25
			}
		}
	}
	
	@objc func clearImage(_ sender: UIPanGestureRecognizer) {
		self.widthBtnRemoveImage.constant = 0
		self.refreshImageView()
	}
	
	fileprivate func cancelClearImage() {
		self.widthBtnRemoveImage.constant = 0
		self.imageView.alpha = 1
	}
	
	@IBAction func uploadToServer(_ sender: Any) {
		let name = txtName.text!
		let author = txtAuthor.text!
		let mediaModel = MediaModel(name:name,author: author,categoryID: idOfCategories.value!)
		let parameters = mediaModel.convertDict()
		AF.upload(multipartFormData: { multipartFormData in
			multipartFormData.append(self.urlOfFile.value!, withName: "Media")
			for (key,value) in parameters {
				if let data = "\(value)".data(using: .utf8) {
					multipartFormData.append(data, withName: key)
				}
			}
		}, to: "\(NetworkServices.hostname)/medias/upload").uploadProgress(closure: { (progress) in
			self.canShowProgressView(isShow: true, value: Float(progress.fractionCompleted))
		}).responseJSON(completionHandler: { (response) in
			switch response.result {
			case.success(let value):
				self.canShowProgressView(isShow: false, value: 0)
				AlertWhenUploadFile.getInstance(self.view).start(status: .success)
				self.uploadWhenComplete()
				print(value)
				break
			case.failure(let error):
				self.canShowProgressView(isShow: false, value: 0)
				AlertWhenUploadFile.getInstance(self.view).start(status: .failure)
				print(error)
			}
			
		})
		
	}
	
	fileprivate func canShowProgressView(isShow:Bool, value: Float) {
		DispatchQueue.main.async {
			self.progressDownLoad.isHidden = !isShow
			self.progressDownLoad.setProgress(value, animated: isShow)
		}
	}
	
	fileprivate func uploadWhenComplete() {
		self.clearData()
	}
	
	fileprivate func clearData() {
		txtName.text = ""
		txtName.isSelected = true
		txtAuthor.text = ""
		txtAlbum.text = ""
		self.idOfCategories.accept(nil)
		self.refreshImageView()
	}
	
	fileprivate func refreshImageView() {
		imageView.image = UIImage(named: "attach")
		self.imageView.alpha = 1
		widthImageView.constant = 48
		urlOfFile.accept(nil)
	}
}

extension UploadServerController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
			urlOfFile.accept(url)
			var image:UIImage? = nil
			if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
				image = imageSelected
			}
			if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
				image = imageOriginal
			}
			if let img = image {
				DispatchQueue.main.async {
					self.widthImageView.constant = self.thumnailmage.frame.width
					self.imageView.image = img
				}}
		} else {
			if let mediaURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
				urlOfFile.accept(mediaURL)
				if let image = UtilityFunc.generateThumnail(url: mediaURL) {
					DispatchQueue.main.async {
						self.widthImageView.constant = self.thumnailmage.frame.width
						self.imageView.image = image
					}
				}
			}}
		picker.dismiss(animated: true) {
			
		}
	}
}

extension UploadServerController: UITextFieldDelegate {
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		textField.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		textField.backgroundColor = .none
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		switch textField {
		case txtName:
			txtAuthor.becomeFirstResponder()
			break
		case txtAuthor:
			txtAlbum.becomeFirstResponder()
			break
		case txtAlbum:
			self.view.endEditing(true)
			break
		default:
			txtName.becomeFirstResponder()
			break
		}
		return true
	}
}

extension UploadServerController: DropDownDelegate {
	func didSelected(_ index: Int) {
		txtAlbum.text = itemsCategory[index].name
		self.idOfCategories.accept(itemsCategory[index]._id)
	}
	
	func handleClose() {
		self.tapScreen.isEnabled = true
	}
}
