//
//  PhotoChallengeViewController.swift
//  PhotoChallenge
//
//  Created by Freddy Hernandez on 12/28/15.
//  Copyright © 2015 Freddy Hernandez. All rights reserved.
//

import UIKit

class PhotoChallengeViewController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
	}

}

extension PhotoChallengeViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	
	@IBAction func showPhotoMenu(sender: UIBarButtonItem) {
		
		/*** 
		Create an alertController with no title and no message
		Configure three buttons for the photo menu
		Add the actions to the alertController
		Present the photo menu
		***/
		let photoMenuController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { _ in print("photo menu cancelled")})
		let takePhotoAction = UIAlertAction(title: "Use Camera", style: .Default, handler: { _ in self.useCamera()})
		let chooseFromLibraryAction = UIAlertAction(title: "Choose From Library", style: .Default, handler: {_ in self.openPhotoLibrary()})
		
		photoMenuController.addAction(cancelAction)
		photoMenuController.addAction(takePhotoAction)
		photoMenuController.addAction(chooseFromLibraryAction)
		
		presentViewController(photoMenuController, animated: true, completion: nil)
	}
	
	func useCamera() {
		if UIImagePickerController.isSourceTypeAvailable(.Camera) {
			let imagePicker = UIImagePickerController()
			imagePicker.sourceType = .Camera
			imagePicker.delegate = self
			imagePicker.allowsEditing = true
			presentViewController(imagePicker, animated: true, completion: nil)
		}
	}
	
	func openPhotoLibrary() {
		if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
			let imagePicker = UIImagePickerController()
			imagePicker.sourceType = .PhotoLibrary
			imagePicker.delegate = self
			imagePicker.allowsEditing = true
			presentViewController(imagePicker, animated: true, completion: nil)
		}
	}
	
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
		
		dismissViewControllerAnimated(true, completion: nil)
		
		if let newImage = info[UIImagePickerControllerEditedImage] {
			
			let photoEditorController = self.storyboard?.instantiateViewControllerWithIdentifier("PhotoEditorViewController") as!PhotoEditorViewController
			photoEditorController.photo = newImage as? UIImage
			presentViewController(photoEditorController, animated: true, completion: nil)
		}
	}
	
}