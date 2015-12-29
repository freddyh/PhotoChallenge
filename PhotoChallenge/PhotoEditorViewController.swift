//
//  PhotoEditorViewController.swift
//  PhotoChallenge
//
//  Created by Freddy Hernandez on 12/28/15.
//  Copyright © 2015 Freddy Hernandez. All rights reserved.
//

import UIKit

struct Constants {
	static let buttonSize:CGFloat = 40.0
}

class PhotoEditorViewController: UIViewController {
	
	@IBOutlet weak var imageContainerView: UIView!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var addTextButton: UIButton!
	@IBOutlet weak var saveButton: UIButton!
	
	var photo:UIImage?
	var textField:UITextField? = nil
	
	override func viewDidAppear(animated: Bool) {

		super.viewDidAppear(animated)
		imageView.image = photo!
	}
	
	@IBAction func addTextFieldButton(sender: UIButton) {
		
		if textField == nil {
			textField = UITextField(frame: CGRectMake(8.0, 50.0, self.imageContainerView.frame.size.width, 40))
			textField!.delegate = self
			textField!.borderStyle = .None
			textField!.returnKeyType = .Done
			imageContainerView.addSubview(textField!)
		}
		
		textField!.becomeFirstResponder()
	}
	
	@IBAction func saveButtonTapped(sender: UIButton) {
		
		UIImageWriteToSavedPhotosAlbum(self.imageFromContainer(), self, "image:hasBeenSavedWithError:contextInfo:", nil)
//		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { _ in
//			
//			})
	}
	
	func image(image:UIImage , hasBeenSavedWithError error: NSError , contextInfo:UnsafePointer<Void>) {
		
		if error.code != 0 {
			print("Error occured when saving image with domain: \(error.domain) and userinfo: \(error.userInfo)")
			dismissViewControllerAnimated(true, completion: nil)
		} else {
			self.showSavedPhotoAlert()
		}
	}
	
	func showSavedPhotoAlert() {
		
		let successAlert = UIAlertController(title: "Successfully Saved", message: "There is a new photo in your library.", preferredStyle: .Alert)
		let doneAction = UIAlertAction(title: "OK", style: .Default, handler: { _ in self.dismissViewControllerAnimated(true, completion: nil)})
		let shareAction = UIAlertAction(title: "Share", style: .Default, handler: nil)
		successAlert.addAction(doneAction)
		successAlert.addAction(shareAction)
		
		presentViewController(successAlert, animated: true, completion: nil)
	}
	
	func imageFromContainer() -> UIImage {
		
		UIGraphicsBeginImageContextWithOptions(imageContainerView.frame.size, true, 0)
		imageContainerView.drawViewHierarchyInRect(imageContainerView.bounds, afterScreenUpdates: true)
		let result = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return result
	}
	
}

extension PhotoEditorViewController : UITextFieldDelegate {
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
	
		textField.resignFirstResponder()
		return true
	}
}
