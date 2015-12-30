//
//  PhotoLabel.swift
//  PhotoChallenge
//
//  Created by Freddy Hernandez on 12/29/15.
//  Copyright © 2015 Freddy Hernandez. All rights reserved.
//

import UIKit

class PhotoLabel: UILabel {
	
	var panRecognizer: UIPanGestureRecognizer?
	var tapRecognizer: UITapGestureRecognizer?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		userInteractionEnabled = true
		panRecognizer = UIPanGestureRecognizer(target: self, action: "detectPan")
		tapRecognizer = UITapGestureRecognizer(target: self, action: "detectTap")
		self.addGestureRecognizer(panRecognizer!)
		self.addGestureRecognizer(tapRecognizer!)
		
		
		textAlignment = .Center
		font = UIFont(name: "Futura", size: 20.0)
		textColor = UIColor.whiteColor()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	func detectPan() {
		let translation = panRecognizer?.translationInView(self)
		self.center.x += (translation?.x)!
		self.center.y += (translation?.y)!
		
		panRecognizer?.setTranslation(CGPointZero, inView: self)
		print("detected Pan")
	}
	
	func detectTap() {
		print("detect tap")
	}
}
