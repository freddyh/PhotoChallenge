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
	var doubleTapRecognizer: UITapGestureRecognizer?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
        
		userInteractionEnabled = true
		panRecognizer = UIPanGestureRecognizer(target: self, action: "detectPan")
		doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "detectedDoubleTap")
		doubleTapRecognizer?.numberOfTapsRequired = 2
		self.addGestureRecognizer(panRecognizer!)
		self.addGestureRecognizer(doubleTapRecognizer!)
		
		
		textAlignment = .Center
		font = UIFont(name: "Futura", size: 20.0)
		textColor = UIColor.whiteColor()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
    /***
     Makes the view draggable
    ***/
	func detectPan() {
		let translation = panRecognizer?.translationInView(self)
		self.center.x += (translation?.x)!
		self.center.y += (translation?.y)!
		
		panRecognizer?.setTranslation(CGPointZero, inView: self)
		print("detected Pan")
	}
	
    /***
     Delete if double tapped
    ***/
	func detectedDoubleTap() {
		self.removeFromSuperview()
	}
}
