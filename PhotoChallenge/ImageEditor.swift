//
//  ImageEditor.swift
//  PhotoChallenge
//
//  Created by Freddy Hernandez on 12/29/15.
//  Copyright © 2015 Freddy Hernandez. All rights reserved.
//

import UIKit

struct Constants {
	static let buttonSize:CGFloat = 60.0
	static let space:CGFloat = 8.0
}

protocol ImageEditorDelegate {
	func imageEditorDidCancel()
	func imageEditorWillOpen()
	func imageEditorDidSaveImage(image:UIImage)
}

class ImageEditor: NSObject {

	var delegate: ImageEditorDelegate?
	var originView: UIView!
	var view: UIView!
	var imageView: UIImageView!
	var saveButton: UIButton!
	var cancelButton: UIButton!
	var insertTextViewButton: UIButton!
	var activityIndicator: UIActivityIndicatorView!
	var textField: UITextField!
	
	var tapRecognizer:UITapGestureRecognizer?
	
	override init() {
		super.init()
	}
	
	/***
	Init will set up the view hierarchy, position buttons on the screen,
	***/
	init(sourceView: UIView, originalImage: UIImage) {
		super.init()
		
		originView = sourceView
		view = UIView(frame: originView.frame)
		originView.addSubview(view)
		
		imageView = UIImageView(frame: originView.frame)
		imageView.image = originalImage
		imageView.userInteractionEnabled = true
		view.addSubview(imageView)
		
		tapRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
		tapRecognizer?.cancelsTouchesInView = false
		view.addGestureRecognizer(tapRecognizer!)
		
		delegate?.imageEditorWillOpen()
		self.setupButtons()
	}
	
	/***
	Puts the text field on the center of the screen with keyboard
	***/
	func showTextField() {
		
		textField = UITextField(frame:CGRectMake(0, view.bounds.height / 2.0 - 8.0, view.bounds.width, 40))
		textField.backgroundColor = UIColor.lightGrayColor()
		textField.becomeFirstResponder()
		textField.returnKeyType = .Done
		textField.delegate = self
		view.addSubview(textField)
	}
	
	
	func setupButtons() {
		
		saveButton = UIButton(frame: CGRectMake(Constants.space, originView.bounds.size.height - (Constants.buttonSize + Constants.space), Constants.buttonSize, Constants.buttonSize))
		saveButton.addTarget(self, action: "saveImage", forControlEvents: .TouchUpInside)
		saveButton.setTitle("⬇︎", forState: .Normal)
		
		cancelButton = UIButton(frame: CGRectMake(Constants.space, Constants.space, Constants.buttonSize, Constants.buttonSize))
		cancelButton.addTarget(self, action: "cancelEditing", forControlEvents: .TouchUpInside)
		cancelButton.setTitle("⌫", forState: .Normal)
		
		insertTextViewButton = UIButton(frame: CGRectMake(originView.bounds.size.width - Constants.buttonSize, Constants.space, Constants.buttonSize, Constants.buttonSize))
		insertTextViewButton.addTarget(self, action: "insertText", forControlEvents: .TouchUpInside)
		insertTextViewButton.setTitle("🆃", forState: .Normal)
		
		view.addSubview(saveButton)
		view.addSubview(cancelButton)
		view.addSubview(insertTextViewButton)
	}
	
	/***
	Starts the loading wheel and saves the photo
	***/
	func saveImage() {
		
		self.beginActivityIndicatorView()
		UIImageWriteToSavedPhotosAlbum(self.getEditedImage(), self, "image:didSaveWithError:contextInfo:", nil)
	}
	
	func beginActivityIndicatorView() {
		
		activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
		activityIndicator.frame = CGRectMake(view.bounds.size.width / 2.0 - Constants.buttonSize, view.bounds.size.height / 2.0 - Constants.buttonSize, Constants.buttonSize, Constants.buttonSize)
		activityIndicator.center = view.center
		view.addSubview(activityIndicator)
		activityIndicator.startAnimating()
	}
	
	func cancelEditing() {
		delegate?.imageEditorDidCancel()
	}
	
	func insertText() {
		self.showTextField()
	}
	
	/***
	Callback after photo is saved to camera roll
	Stops the spinning wheel and notifies delegate
	***/
	func image(image:UIImage, didSaveWithError error:NSError, contextInfo:UnsafePointer<Void>) {
		
		if error.code == 0 {
			activityIndicator.stopAnimating()
			activityIndicator.removeFromSuperview()
			delegate?.imageEditorDidSaveImage(image)
		} else {
			print("Error Code: \(error.code) Error User Info: \(error.userInfo)")
		}
		
	}
	
	/***
	Returns the imageView with any text that has been added as subviews
	***/
	func getEditedImage() -> UIImage {
		UIGraphicsBeginImageContextWithOptions(imageView.frame.size, true, 0)
		imageView.drawViewHierarchyInRect(imageView.bounds, afterScreenUpdates: true)
		let result = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return result
	}
	
	func dismissKeyboard() {
		view.endEditing(true)
	}
	
	deinit {
		view.removeFromSuperview()
		view = nil
	}
}

extension ImageEditor : UITextFieldDelegate {
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		self.dismissKeyboard()
		return true
	}
	
	func textFieldDidEndEditing(textField: UITextField) {
		
		self.removeTextField()
	}
	
	func removeTextField() {
		self.addTextLabelWithText(textField.text!)
		textField.removeFromSuperview()
	}
	
	func addTextLabelWithText(text:String) {
		let label = PhotoLabel()
		label.text = text
		label.sizeToFit()
		label.center = view.center
		imageView.addSubview(label)
	}
}
