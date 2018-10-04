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
        isUserInteractionEnabled = true
		numberOfLines = 0
        
        panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(PhotoLabel.move))
		panRecognizer?.delegate = self
		
        doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(PhotoLabel.incrementSizeStage))
		doubleTapRecognizer?.numberOfTapsRequired = 2
		doubleTapRecognizer?.delegate = self
		
        longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(PhotoLabel.deletePhotoLabel))
		longPressRecognizer?.minimumPressDuration = 1.5
		longPressRecognizer?.delegate = self
		
        pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(PhotoLabel.stretch))
		pinchRecognizer?.delegate = self
		
        rotationRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(PhotoLabel.handleRotate))
        rotationRecognizer?.delegate = self
		
		self.addGestureRecognizer(panRecognizer!)
		self.addGestureRecognizer(doubleTapRecognizer!)
		self.addGestureRecognizer(longPressRecognizer!)
		self.addGestureRecognizer(pinchRecognizer!)
		self.addGestureRecognizer(rotationRecognizer!)
		
		/***
		Center the text and change the font name, size, and color
		***/
        textAlignment = .center
		font = UIFont(name: "Futura", size: 20.0)
        textColor = UIColor.white
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	

	/***
	Panning on the label will drag
	***/
	@objc func move() {
        let translation = panRecognizer?.translation(in: self.superview!)
		self.center.x += (translation?.x)!
		self.center.y += (translation?.y)!
        panRecognizer?.setTranslation(CGPoint.zero, in: self)
	}
	
    /***
     Cycle through different sizes and alignments
    ***/
	@objc func incrementSizeStage() {
		
		sizeStage += 1
		if sizeStage > 3 {
			sizeStage = 0
		}

		switch sizeStage {
			case 0:
				//Center the label and size it similar to textField
				self.center = (self.superview?.center)!
                self.font = UIFont.systemFont(ofSize: 25)
			
			case 1:
				//Increase frame size and font
				let height = (self.superview?.bounds.height)! * 0.4
                self.textAlignment = .center
                self.frame = CGRect(x: 0, y: 0, width: (self.superview?.bounds.width)!, height: height)
				self.center = (self.superview?.center)!
                self.font = UIFont.systemFont(ofSize: 50)
			
			case 2:
				//Right align text
				self.textAlignment = .right
			
			case 3:
				//Left align text
				self.textAlignment = .left
			default: break
		}
	}
	
	@objc func deletePhotoLabel() {
		
		self.removeFromSuperview()
	}
	
	@objc func stretch() {
		
		if let recognizer = pinchRecognizer {
			switch recognizer.state {
            case UIGestureRecognizer.State.began:
				break
            case UIGestureRecognizer.State.changed:
				recognizer.view?.transform = CGAffineTransform.init(scaleX: recognizer.scale, y: recognizer.scale)
//                ((recognizer.view?.transform)!, recognizer.scale, recognizer.scale)
				recognizer.scale = 1.0
            case UIGestureRecognizer.State.ended:
				break
			default: break
			}
		}
	}
	
	@objc func handleRotate() {
		if let recognizer = rotationRecognizer {
			recognizer.view?.transform = CGAffineTransform.init(rotationAngle: recognizer.rotation)
//                CGAffineTransformRotate((recognizer.view?.transform)!, recognizer.rotation)
			recognizer.rotation = 0.0
		}
	}
}

extension PhotoLabel : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}
}


























