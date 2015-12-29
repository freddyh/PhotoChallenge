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
	
	var photo:UIImage?
	var textField:UITextField?
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	override func viewDidAppear(animated: Bool) {

		super.viewDidAppear(animated)
		self.setupPhotoEditorSubViews()
	}
	
	func setupPhotoEditorSubViews() {
		
		imageView.image = photo!
	}
	
	@IBAction func addTextFieldButton(sender: UIButton) {
		
		textField = UITextField(frame: CGRectMake(8.0, 8.0, self.imageContainerView.frame.size.width, 40))
		textField?.delegate = self
		textField?.returnKeyType = .Done
		imageContainerView.addSubview(textField!)
		textField?.becomeFirstResponder()
	}
}

extension PhotoEditorViewController : UITextFieldDelegate {
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
	
		textField.resignFirstResponder()
		return true
	}
}
