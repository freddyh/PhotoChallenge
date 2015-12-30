//
//  ImageEditor.swift
//  PhotoChallenge
//
//  Created by Freddy Hernandez on 12/29/15.
//  Copyright © 2015 Freddy Hernandez. All rights reserved.
//

import UIKit

struct Constants {
	static let buttonSize:CGFloat = 40.0
	static let space:CGFloat = 8.0
}

protocol ImageEditorDelegate {
	func imageEditorDidCancel()
	func imageEditorWillOpen()
	func imageEditorDidSaveImage()
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
		saveButton.setTitle("⥥", forState: .Normal)
		
		//top left - cancelButton
		cancelButton = UIButton(frame: CGRectMake(Constants.space, Constants.space, Constants.buttonSize, Constants.buttonSize))
		cancelButton.addTarget(self, action: "cancelEditing", forControlEvents: .TouchUpInside)
		cancelButton.setTitle("✗", forState: .Normal)
		
		//top right - insertTextButton
		insertTextViewButton = UIButton(frame: CGRectMake(originView.bounds.size.width - Constants.buttonSize, Constants.space, Constants.buttonSize, Constants.buttonSize))
		insertTextViewButton.addTarget(self, action: "insertText", forControlEvents: .TouchUpInside)
		insertTextViewButton.setTitle("T", forState: .Normal)
		
		view.addSubview(saveButton)
		view.addSubview(cancelButton)
		view.addSubview(insertTextViewButton)
	}
	
	func saveImage() {
		delegate?.imageEditorDidSaveImage()
		//save to photos library
		//allow user ot continue editing
		//loading wheel?
		//completion alert
	}
	
	func cancelEditing() {
		delegate?.imageEditorDidCancel()
		//dismiss
		//call delegate method to remove from view, isEditing = false
	}
	
	func insertText() {
		print("insert text button")
		//create UITextField
		//add UILabel to self.textLabels
		
	}
	
	deinit {
		view.removeFromSuperview()
		view = nil
	}
}
