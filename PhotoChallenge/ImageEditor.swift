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
	var textLabelsArray: Array<UILabel>!
	var activityIndicator: UIActivityIndicatorView!
	
	override init() {
		super.init()
	}
	
	init(sourceView: UIView, originalImage: UIImage) {
		super.init()
		
		originView = sourceView
		view = UIView(frame: originView.frame)
		originView.addSubview(view)
		imageView = UIImageView(frame: originView.frame)
		imageView.image = originalImage
		
		view.addSubview(imageView)
		
		textLabelsArray = []
		
		delegate?.imageEditorWillOpen()
		self.setupButtons()
	}
	
	func setupButtons() {
		
		/****
		bottom left - saveButton
		****/
		saveButton = UIButton(frame: CGRectMake(Constants.space, originView.bounds.size.height - (Constants.buttonSize + Constants.space), Constants.buttonSize, Constants.buttonSize))
		saveButton.addTarget(self, action: "saveImage", forControlEvents: .TouchUpInside)
		saveButton.setTitle("⬇︎", forState: .Normal)
		
		//top left - cancelButton
		cancelButton = UIButton(frame: CGRectMake(Constants.space, Constants.space, Constants.buttonSize, Constants.buttonSize))
		cancelButton.addTarget(self, action: "cancelEditing", forControlEvents: .TouchUpInside)
		cancelButton.setTitle("⌫", forState: .Normal)
		
		
		//top right - insertTextButton
		insertTextViewButton = UIButton(frame: CGRectMake(originView.bounds.size.width - Constants.buttonSize, Constants.space, Constants.buttonSize, Constants.buttonSize))
		insertTextViewButton.addTarget(self, action: "insertText", forControlEvents: .TouchUpInside)
		insertTextViewButton.setTitle("🆃", forState: .Normal)
		
		view.addSubview(saveButton)
		view.addSubview(cancelButton)
		view.addSubview(insertTextViewButton)
	}
	
	func initActivityIndicatorView() {
		
		activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
		activityIndicator.frame = CGRectMake(view.bounds.size.width / 2.0 - Constants.buttonSize, view.bounds.size.height / 2.0 - Constants.buttonSize, Constants.buttonSize, Constants.buttonSize)
		view.addSubview(activityIndicator)
		activityIndicator.startAnimating()
	}
	
	func saveImage() {
		
		self.initActivityIndicatorView()
		UIImageWriteToSavedPhotosAlbum(self.getEditedImage(), self, "image:hasBeenSavedWithError:contextInfo:", nil)
	}
	
	func cancelEditing() {
		delegate?.imageEditorDidCancel()
	}
	
	func insertText() {
		
		print("insert text button")
		//create UITextField
		//add UILabel to self.textLabels
		
	}
	
	func image(image:UIImage, hasBeenSavedWithError error:NSError, contextInfo:UnsafePointer<Void>) {
		
		if error.code == 0 {
			activityIndicator.stopAnimating()
			activityIndicator.removeFromSuperview()
			delegate?.imageEditorDidSaveImage(image)
		}
		
	}
	
	func getEditedImage() -> UIImage {
		UIGraphicsBeginImageContextWithOptions(imageView.frame.size, true, 0)
		imageView.drawViewHierarchyInRect(imageView.bounds, afterScreenUpdates: true)
		let result = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return result
	}
	
	deinit {
		view.removeFromSuperview()
		view = nil
	}
}
