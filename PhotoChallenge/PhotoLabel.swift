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
	
	var sizeStage:Int = 0
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		userInteractionEnabled = true
        
		panRecognizer = UIPanGestureRecognizer(target: self, action: "move")
		doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "incrementSizeStage")
		doubleTapRecognizer?.numberOfTapsRequired = 2
        
		self.addGestureRecognizer(panRecognizer!)
		self.addGestureRecognizer(doubleTapRecognizer!)
		
		/***
		Center the text and change the font name, size, and color
		***/
		textAlignment = .Center
		font = UIFont(name: "Futura", size: 20.0)
		textColor = UIColor.whiteColor()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	

	/***
	Panning on the label will drag
	***/
	func move() {
		let translation = panRecognizer?.translationInView(self)
		self.center.x += (translation?.x)!
		self.center.y += (translation?.y)!
		
		panRecognizer?.setTranslation(CGPointZero, inView: self)
	}
	
    /***
     Cycle through different sizes and alignments
    ***/
	func incrementSizeStage() {
		
		sizeStage += 1
		if sizeStage > 3 {
			sizeStage = 0
		}

		switch sizeStage {
			case 0:
				let height = (self.superview?.bounds.height)! * 0.1
				let width = (self.superview?.bounds.width)!

				self.frame = CGRectMake(0, height * 0.5, width, height)
				self.font = UIFont.systemFontOfSize(14)
				self.numberOfLines = 1
			case 1:
				let height = (self.superview?.bounds.height)! * 0.7
				let width = (self.superview?.bounds.width)! * 0.9
				
				self.frame = CGRectMake(0, height * 0.2, width, height)
				self.font = UIFont.systemFontOfSize(50)
				self.numberOfLines = 0
			case 2:
				let height = (self.superview?.bounds.height)! * 0.7
				let width = (self.superview?.bounds.width)! * 0.9
				
				self.frame = CGRectMake(0, height * 0.2, width, height)
				self.textAlignment = .Right
				self.font = UIFont.systemFontOfSize(50)
				self.numberOfLines = 0
			case 3:
				let height = (self.superview?.bounds.height)! * 0.7
				let width = (self.superview?.bounds.width)! * 0.9
				
				self.frame = CGRectMake(0, height * 0.2, width, height)
				self.textAlignment = .Left
				self.font = UIFont.systemFontOfSize(50)
				self.numberOfLines = 0
			default: break
		}
	}
}


























