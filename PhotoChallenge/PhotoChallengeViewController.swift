//
//  PhotoChallengeViewController.swift
//  PhotoChallenge
//
//  Created by Freddy Hernandez on 12/28/15.
//  Copyright © 2015 Freddy Hernandez. All rights reserved.
//

import UIKit

class PhotoChallengeViewController: UIViewController {
	
//	let imagePickerController = UIImagePickerController()

	@IBAction func takePhotoButtonTapped(sender: UIButton) {
		
		
	}
	
	@IBAction func choosePhotoButtonTapped(sender: UIButton) {
		
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

extension PhotoChallengeViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	
	@IBAction func showPhotoMenu(sender: UIBarButtonItem) {
		
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
		print("open camera")
		
		let imagePicker = UIImagePickerController()
		imagePicker.sourceType = .Camera
		imagePicker.delegate = self
		imagePicker.allowsEditing = true
		presentViewController(imagePicker, animated: true, completion: nil)
		
	}
	
	func openPhotoLibrary() {
		let imagePicker = UIImagePickerController()
		imagePicker.sourceType = .PhotoLibrary
		imagePicker.delegate = self
		imagePicker.allowsEditing = true
		presentViewController(imagePicker, animated: true, completion: nil)

		print("open photo library")
	}
	
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		print("image picker did cancel")
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
		print("image picker did finishPickingImage")
		
		//do stuff with the the image
		dismissViewControllerAnimated(true, completion: nil)
		
	}
}