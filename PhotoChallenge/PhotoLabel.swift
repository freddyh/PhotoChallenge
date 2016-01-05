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
	var longPressRecognizer: UILongPressGestureRecognizer?
	var pinchRecognizer: UIPinchGestureRecognizer?
	var rotationRecognizer: UIRotationGestureRecognizer?
	
	var sizeStage:Int = 0
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		userInteractionEnabled = true
		numberOfLines = 0
        
		panRecognizer = UIPanGestureRecognizer(target: self, action: "move")
		panRecognizer?.delegate = self
		
		doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "incrementSizeStage")
		doubleTapRecognizer?.numberOfTapsRequired = 2
		doubleTapRecognizer?.delegate = self
		
		longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "deletePhotoLabel")
		longPressRecognizer?.minimumPressDuration = 1.5
		longPressRecognizer?.delegate = self
		
		pinchRecognizer = UIPinchGestureRecognizer(target: self, action: "stretch")
		pinchRecognizer?.delegate = self
		
		rotationRecognizer = UIRotationGestureRecognizer(target: self, action: "handleRotate")
        rotationRecognizer?.delegate = self
		
		self.addGestureRecognizer(panRecognizer!)
		self.addGestureRecognizer(doubleTapRecognizer!)
		self.addGestureRecognizer(longPressRecognizer!)
		self.addGestureRecognizer(pinchRecognizer!)
		self.addGestureRecognizer(rotationRecognizer!)
		
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
		let translation = panRecognizer?.translationInView(self.superview!)
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
				//Center the label and size it similar to textField
				self.center = (self.superview?.center)!
				self.font = UIFont.systemFontOfSize(25)
			
			case 1:
				//Increase frame size and font
				let height = (self.superview?.bounds.height)! * 0.4
				self.textAlignment = .Center
				self.frame = CGRectMake(0, 0, (self.superview?.bounds.width)!, height)
				self.center = (self.superview?.center)!
				self.font = UIFont.systemFontOfSize(50)
			
			case 2:
				//Right align text
				self.textAlignment = .Right
			
			case 3:
				//Left align text
				self.textAlignment = .Left
			default: break
		}
	}
	
	func deletePhotoLabel() {
		
		self.removeFromSuperview()
	}
	
	func stretch() {
		
		if let recognizer = pinchRecognizer {
			switch recognizer.state {
			case UIGestureRecognizerState.Began:
				break
			case UIGestureRecognizerState.Changed:
				recognizer.view?.transform = CGAffineTransformScale((recognizer.view?.transform)!, recognizer.scale, recognizer.scale)
				recognizer.scale = 1.0
			case UIGestureRecognizerState.Ended:
				break
			default: break
			}
		}
	}
	
	func handleRotate() {
		if let recognizer = rotationRecognizer {
			recognizer.view?.transform = CGAffineTransformRotate((recognizer.view?.transform)!, recognizer.rotation)
			recognizer.rotation = 0.0
		}
	}
}

extension PhotoLabel : UIGestureRecognizerDelegate {
	func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}
}


























