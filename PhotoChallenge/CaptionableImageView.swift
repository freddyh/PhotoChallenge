//
//  CaptionableImageView.swift
//  PhotoChallenge
//
//  Created by Freddy Hernandez on 1/3/16.
//  Copyright © 2016 Freddy Hernandez. All rights reserved.
//

import UIKit

let FilterNames = ["CIComicEffect", "CIColorInvert", "CIColorPosterize", "CIPhotoEffectChrome", "CIPhotoEffectFade", "CIPhotoEffectInstant", "CIPhotoEffectMono", "CIPhotoEffectNoir", "CIPhotoEffectProcess", "CIPhotoEffectTonal", "CIPhotoEffectTransfer", "CISepiaTone", "CICrystallize", "CIEdges", "CIEdgeWork", "CIHexagonalPixellate"]

class CaptionableImageView: UIImageView {

	var originalImage: UIImage!
	private var filterIndex:Int = -1
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		userInteractionEnabled = true
		let swipeLeftRecognizer = UISwipeGestureRecognizer(target: self, action: "updateFilterIndex:")
		swipeLeftRecognizer.direction = .Left
		swipeLeftRecognizer.numberOfTouchesRequired = 1
		swipeLeftRecognizer.delegate = self
		
		let swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: "updateFilterIndex:")
		swipeRightRecognizer.direction = .Right
		swipeRightRecognizer.numberOfTouchesRequired = 1
		swipeRightRecognizer.delegate = self
		
		addGestureRecognizer(swipeLeftRecognizer)
		addGestureRecognizer(swipeRightRecognizer)
	}
	
	var currentImage: UIImage {
		get {
			UIGraphicsBeginImageContextWithOptions(frame.size, true, 0)
			drawViewHierarchyInRect(bounds, afterScreenUpdates: true)
			let result = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
			
			return result
		}
	}
	
	func updateFilterIndex(sender:UISwipeGestureRecognizer) {
		
		
		switch sender.direction {
		case UISwipeGestureRecognizerDirection.Right:
			if filterIndex == -1 {
				filterIndex = FilterNames.count - 1
			} else {
				filterIndex--
			}
		case UISwipeGestureRecognizerDirection.Left:
			if filterIndex == FilterNames.count - 1 {
				filterIndex = -1
			} else {
				filterIndex++
			}
		default:break
		}
		
		updateImageWithFilter()
	}
	
	func updateImageWithFilter() {
		
		if filterIndex == -1 {
			image = originalImage!
		} else {
			let filterName = FilterNames[filterIndex]
			let stillImageFilter = CIFilter(name: filterName, withInputParameters: [kCIInputImageKey:CIImage(image: originalImage!)!])
			
			image = UIImage(CIImage: stillImageFilter?.valueForKey(kCIOutputImageKey) as! CIImage, scale: 1.0, orientation: UIImageOrientation.Up)
		}
	}
	
	func insertCaptionWithText(text:String) {
		
		let label = PhotoLabel()
		label.text = text
		label.frame = CGRectMake(0, 0, (self.superview?.bounds.width)!, 60)
		label.center = center
		addSubview(label)
	}
	
	func removeCaptions() {
		for photoLabel in subviews {
			photoLabel.removeFromSuperview()
		}
	}
	
}

extension CaptionableImageView : UIGestureRecognizerDelegate {
	
	
	//Prevent the filter from changing if the user is trying to drag a label
	func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOfGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		

		if subviews.count > 0 {
			for photoLabel in subviews {
				if (photoLabel as! PhotoLabel).panRecognizer == otherGestureRecognizer {
					return true
				}
				
			}
		}

		return false
	}
}
