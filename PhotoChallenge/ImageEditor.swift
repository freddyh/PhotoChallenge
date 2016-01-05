//
//  ImageEditor.swift
//  PhotoChallenge
//
//  Created by Freddy Hernandez on 12/29/15.
//  Copyright © 2015 Freddy Hernandez. All rights reserved.
//

//Check image dimensions
//Need to adjust the size of an image if it comes from the photo library

import UIKit

struct Constants {
	static let buttonSize:CGFloat = 60.0
	static let space:CGFloat = 8.0
}

protocol ImageEditorDelegate : class {
	func imageEditorDidLoad()
	func imageEditorDidCancel()
	func imageEditorDidSaveImage(image:UIImage)
	func imageEditorDidShare(image:UIImage)
}

class ImageEditor: NSObject {

	weak var delegate: ImageEditorDelegate?
	weak var superView: UIView!
	var view: UIView!
	var captionableImageView: CaptionableImageView!
	var saveButton: UIButton!
	var cancelButton: UIButton!
	var shareButton: UIButton!
	var insertTextViewButton: UIButton!
	var activityIndicator: UIActivityIndicatorView!
	var textField: UITextField!
	var originalImage: UIImage!
	
	var tapRecognizer:UITapGestureRecognizer?
	
	override init() {
		super.init()
	}
	
	/***
	Init will set up the view hierarchy, position buttons on the screen
	***/
	init(sourceView: UIView, originalImage: UIImage) {
		super.init()
		
		self.originalImage = originalImage
		
		superView = sourceView
		view = UIView(frame: superView.frame)
		view.backgroundColor = UIColor.blackColor()
		superView.addSubview(view)
		
		captionableImageView = CaptionableImageView(image: originalImage, highlightedImage: nil)
		captionableImageView.frame = view.frame
		view.addSubview(captionableImageView)
		
		tapRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
		tapRecognizer?.cancelsTouchesInView = false
		view.addGestureRecognizer(tapRecognizer!)
		
		self.setupButtons()
		
		delegate?.imageEditorDidLoad()
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
		textField.alpha = 0.5
		view.addSubview(textField)
	}
	
	func setupButtons() {
		
		saveButton = UIButton(frame: CGRectMake(Constants.space, superView.bounds.size.height - (Constants.buttonSize + Constants.space), Constants.buttonSize, Constants.buttonSize))
		saveButton.titleLabel?.font = UIFont.systemFontOfSize(30)
		saveButton.addTarget(self, action: "saveImage", forControlEvents: .TouchUpInside)
		saveButton.setTitle("⬇︎", forState: .Normal)
		
		cancelButton = UIButton(frame: CGRectMake(Constants.space, Constants.space, Constants.buttonSize, Constants.buttonSize))
		cancelButton.addTarget(self, action: "cancelEditing", forControlEvents: .TouchUpInside)
		cancelButton.titleLabel?.font = UIFont.systemFontOfSize(30)
		cancelButton.setTitle("⌫", forState: .Normal)
		
		shareButton = UIButton(frame: CGRectMake(superView.bounds.size.width - (Constants.buttonSize + Constants.space), superView.bounds.size.height - (Constants.buttonSize + Constants.space), Constants.buttonSize, Constants.buttonSize))
		shareButton.addTarget(self, action: "sharePhoto", forControlEvents: .TouchUpInside)
		shareButton.titleLabel?.font = UIFont.systemFontOfSize(60)
		shareButton.setTitle("⊼", forState: .Normal)
		
		insertTextViewButton = UIButton(frame: CGRectMake(superView.bounds.size.width - Constants.buttonSize, Constants.space, Constants.buttonSize, Constants.buttonSize))
		insertTextViewButton.titleLabel?.font = UIFont.systemFontOfSize(30)
		insertTextViewButton.addTarget(self, action: "insertText", forControlEvents: .TouchUpInside)
		insertTextViewButton.setTitle("🆃", forState: .Normal)
		
		view.addSubview(saveButton)
		view.addSubview(cancelButton)
		view.addSubview(shareButton)
		view.addSubview(insertTextViewButton)
	}
	
	/***
	Starts the loading wheel and saves the photo
	***/
	func saveImage() {
		
		self.beginActivityIndicatorView()
		UIImageWriteToSavedPhotosAlbum(captionableImageView.currentImage, self, "image:didSaveWithError:contextInfo:", nil)
	}
	
	func beginActivityIndicatorView() {
		
		saveButton.enabled = false
		activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
		activityIndicator.frame = CGRectMake(view.bounds.size.width / 2.0 - Constants.buttonSize, view.bounds.size.height / 2.0 - Constants.buttonSize, Constants.buttonSize, Constants.buttonSize)
		activityIndicator.center = view.center
		view.addSubview(activityIndicator)
		activityIndicator.startAnimating()
	}
	
	/******************************************
	Callback after photo is saved to camera roll
	Stops the spinning wheel and notifies delegate
	*********************************************/
	func image(image:UIImage, didSaveWithError error:NSError, contextInfo:UnsafePointer<Void>) {
		
		if error.code == 0 {
			activityIndicator.stopAnimating()
			activityIndicator.removeFromSuperview()
			saveButton.enabled = true
			delegate?.imageEditorDidSaveImage(image)
		} else {
			print("Error Code: \(error.code) Error User Info: \(error.userInfo)")
		}
		
	}
	
	func sharePhoto() {
		delegate?.imageEditorDidShare(captionableImageView.currentImage)
	}
	
    func cancelEditing() {
        delegate?.imageEditorDidCancel()
    }
    
    func insertText() {
        self.showTextField()
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
		
		captionableImageView.insertCaptionWithText(textField.text!)
		textField.removeFromSuperview()
	}
}
