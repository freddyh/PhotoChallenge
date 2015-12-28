//
//  ViewController.swift
//  PhotoChallenge
//
//  Created by Freddy Hernandez on 12/28/15.
//  Copyright © 2015 Freddy Hernandez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBAction func takePhotoButtonTapped(sender: UIButton) {
		print("open camera")
	}
	
	@IBAction func choosePhotoButtonTapped(sender: UIButton) {
		print("open photo library")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

