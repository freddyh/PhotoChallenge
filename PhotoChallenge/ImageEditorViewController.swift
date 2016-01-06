//
//  ImageEditorViewController.swift
//  PhotoChallenge
//
//  Created by Freddy Hernandez on 1/4/16.
//  Copyright © 2016 Freddy Hernandez. All rights reserved.
//

import UIKit

protocol ImageEditorDelegate : class {

	func imageEditorDidCancel()
}

class ImageEditorViewController: UIViewController {
	
	
	@IBOutlet weak var captionableImageView: CaptionableImageView!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var saveButton: UIBarButtonItem!
	@IBOutlet weak var textField: UITextField!
	weak var delegate: ImageEditorDelegate?
	var originalImage: UIImage!
	var tapRecognizer:UITapGestureRecognizer?
	

    override func viewDidLoad() {
        super.viewDidLoad()
		
		tapRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
		tapRecognizer?.cancelsTouchesInView = false
		view.addGestureRecognizer(tapRecognizer!)

    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		//Update the image
		captionableImageView.image = originalImage
		captionableImageView.originalImage = originalImage
	}
	
	@IBAction func cancel(sender: AnyObject) {
		delegate?.imageEditorDidCancel()
		captionableImageView.removeCaptions()
	}
	
	@IBAction func insertCaption(sender: UIButton) {
		self.view.bringSubviewToFront(textField)
		textField.becomeFirstResponder()
		textField.hidden = false
	}
	
	@IBAction func save(sender: UIBarButtonItem) {
		
		saveButton.enabled = false
		self.view.bringSubviewToFront(activityIndicator)
		activityIndicator.startAnimating()
		UIImageWriteToSavedPhotosAlbum(captionableImageView.currentImage, self, "image:didSaveWithError:contextInfo:", nil)
	}
	
	@IBAction func share(sender: UIBarButtonItem) {
		
		let activityController = UIActivityViewController(activityItems: [captionableImageView.currentImage], applicationActivities: nil)
		presentViewController(activityController, animated: true, completion: nil)
	}
	
	func image(image:UIImage, didSaveWithError error:NSError, contextInfo:UnsafePointer<Void>) {
		
		activityIndicator.stopAnimating()
		
		if error.code == 0 {
			saveButton.enabled = true
			self.showSavedPhotoAlert()
		} else {
			print("Error Code: \(error.code) Error User Info: \(error.userInfo)")
		}
		
	}
	
	func dismissKeyboard() {
		view.endEditing(true)
	}
	
	func showSavedPhotoAlert() {
		
		//Confirmation that the image did save to the Camera Roll
		//Requires user to press "OK" to dismiss
		let successAlert = UIAlertController(title: "Successfully Saved", message: "There is a new photo in your library.", preferredStyle: .Alert)
		let doneAction = UIAlertAction(title: "Thanks", style: .Default, handler: nil)
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
		textField.hidden = true
		captionableImageView.insertCaptionWithText(textField.text!)
	}
}
