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
		
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ImageEditorViewController.dismissKeyboard))
		tapRecognizer?.cancelsTouchesInView = false
		view.addGestureRecognizer(tapRecognizer!)

    }
	
    override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		//Update the image
		captionableImageView.image = originalImage
		captionableImageView.originalImage = originalImage
	}
	
	@IBAction func cancel(_ sender: AnyObject) {
		delegate?.imageEditorDidCancel()
		captionableImageView.removeCaptions()
	}
	
	@IBAction func insertCaption(_ sender: UIButton) {
        self.view.bringSubviewToFront(textField)
		textField.becomeFirstResponder()
        textField.isHidden = false
	}
	
	@IBAction func save(_ sender: UIBarButtonItem) {
		
        saveButton.isEnabled = false
        self.view.bringSubviewToFront(activityIndicator)
		activityIndicator.startAnimating()
        UIImageWriteToSavedPhotosAlbum(captionableImageView.currentImage, self, #selector(ImageEditorViewController.image(_:didSaveWithError:contextInfo:)), nil)
	}
	
	@IBAction func share(_ sender: UIBarButtonItem) {
		
		let activityController = UIActivityViewController(activityItems: [captionableImageView.currentImage], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
	}
    
    @objc func image(_ image:UIImage, didSaveWithError error:NSError, contextInfo:UnsafeRawPointer) {
		
		activityIndicator.stopAnimating()
		
		if error.code == 0 {
            saveButton.isEnabled = true
			self.showSavedPhotoAlert()
		} else {
			print("Error Code: \(error.code) Error User Info: \(error.userInfo)")
		}
		
	}
	
	@objc func dismissKeyboard() {
		view.endEditing(true)
	}
	
	func showSavedPhotoAlert() {
		
		//Confirmation that the image did save to the Camera Roll
		//Requires user to press "OK" to dismiss
        let successAlert = UIAlertController(title: "Successfully Saved", message: "There is a new photo in your library.", preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "Thanks", style: .default, handler: nil)
		successAlert.addAction(doneAction)
		
        present(successAlert, animated: true, completion: nil)
	}
	
}

extension ImageEditorViewController : UITextFieldDelegate {
	
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.dismissKeyboard()
		return true
	}
	
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.isHidden = true
        captionableImageView.insertCaptionWithText(text: textField.text!)
	}
}
