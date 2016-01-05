//
//  ImageEditorViewController.swift
//  PhotoChallenge
//
//  Created by Freddy Hernandez on 1/4/16.
//  Copyright © 2016 Freddy Hernandez. All rights reserved.
//

import UIKit

protocol ImageEditorDelegate : class {
	func imageEditorDidLoad()
	func imageEditorDidCancel()
	func imageEditorDidSaveImage(image:UIImage)
	func imageEditorDidShare()
}

class ImageEditorViewController: UIViewController {
	
	
	@IBOutlet weak var captionableImageView: CaptionableImageView!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var saveButton: UIBarButtonItem!
	weak var delegate: ImageEditorDelegate?
	var textField: UITextField!
	var originalImage: UIImage!
	var tapRecognizer:UITapGestureRecognizer?
	

    override func viewDidLoad() {
        super.viewDidLoad()
		
		tapRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
		tapRecognizer?.cancelsTouchesInView = false
		view.addGestureRecognizer(tapRecognizer!)
		
		
		
		delegate?.imageEditorDidLoad()
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		captionableImageView.image = originalImage
		captionableImageView.originalImage = originalImage
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	@IBAction func cancel(sender: AnyObject) {
		delegate?.imageEditorDidCancel()
		captionableImageView.removeCaptions()
	}
	
	@IBAction func insertCaption(sender: UIButton) {
		self.showTextField()
	}
	
	@IBAction func save(sender: UIBarButtonItem) {
		
		self.beginActivityIndicatorView()
		UIImageWriteToSavedPhotosAlbum(captionableImageView.currentImage, self, "image:didSaveWithError:contextInfo:", nil)
	}
	
	@IBAction func share(sender: UIBarButtonItem) {
		let activityController = UIActivityViewController(activityItems: [captionableImageView.currentImage], applicationActivities: nil)
		
		presentViewController(activityController, animated: true, completion: { _ in
		self.delegate?.imageEditorDidShare()})
		
	}
	
	func showTextField() {
		
		textField = UITextField(frame:CGRectMake(0, view.bounds.height / 2.0 - 8.0, view.bounds.width, 40))
		textField.backgroundColor = UIColor.lightGrayColor()
		textField.becomeFirstResponder()
		textField.returnKeyType = .Done
		textField.delegate = self
		textField.alpha = 0.5
		view.addSubview(textField)
	}
	
	func beginActivityIndicatorView() {
		
		saveButton.enabled = false
		activityIndicator.startAnimating()
	}
	
	func image(image:UIImage, didSaveWithError error:NSError, contextInfo:UnsafePointer<Void>) {
		
		if error.code == 0 {
			activityIndicator.stopAnimating()
			saveButton.enabled = true
			self.showSavedPhotoAlert()
			delegate?.imageEditorDidSaveImage(image)
		} else {
			print("Error Code: \(error.code) Error User Info: \(error.userInfo)")
		}
		
	}
	
	func dismissKeyboard() {
		view.endEditing(true)
	}
	
	func showSavedPhotoAlert() {
		
		/***
		Show an alert that confirms the photo was saved and give an option to share the photo
		If user pressed "Share" then the image is passed to a UIActivityViewController
		***/
		let successAlert = UIAlertController(title: "Successfully Saved", message: "There is a new photo in your library.", preferredStyle: .Alert)
		let doneAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
		
		successAlert.addAction(doneAction)
		
		presentViewController(successAlert, animated: true, completion: nil)
	}
	
}

extension ImageEditorViewController : UITextFieldDelegate {
	
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
