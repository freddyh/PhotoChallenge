//
//  CaptionableImageView.swift
//  PhotoChallenge
//
//  Created by Freddy Hernandez on 1/3/16.
//  Copyright © 2016 Freddy Hernandez. All rights reserved.
//

import UIKit

let FilterNames = ["CIColorInvert", "CIColorPosterize", "CIPhotoEffectChrome", "CIPhotoEffectFade", "CIPhotoEffectInstant", "CIPhotoEffectMono", "CIPhotoEffectNoir", "CIPhotoEffectProcess", "CIPhotoEffectTonal", "CIPhotoEffectTransfer", "CISepiaTone"]

class CaptionableImageView: UIImageView {

	var originalImage:UIImage?
	var filterIndex:Int = -1

	override init(frame: CGRect) {
		super.init(frame: frame)
		
		userInteractionEnabled = true
		let swipeLeftRecognizer = UISwipeGestureRecognizer(target: self, action: "updateFilterIndex:")
		swipeLeftRecognizer.direction = .Left
		swipeLeftRecognizer.numberOfTouchesRequired = 1
		
		let swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: "updateFilterIndex:")
		swipeRightRecognizer.direction = .Right
		swipeRightRecognizer.numberOfTouchesRequired = 1

		addGestureRecognizer(swipeLeftRecognizer)
		addGestureRecognizer(swipeRightRecognizer)
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
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
			filterIndex--
		case UISwipeGestureRecognizerDirection.Left:
			filterIndex++
		default:break
		}
		
		if filterIndex == FilterNames.count {
			filterIndex = -1
			image = originalImage
		} else if filterIndex == -1 {
			filterIndex += FilterNames.count
		} else {
		
			let filterName = FilterNames[filterIndex]
			let stillImageFilter = CIFilter(name: filterName, withInputParameters: [kCIInputImageKey:CIImage(image: originalImage!)!])
			
			image = UIImage(CIImage: stillImageFilter?.valueForKey(kCIOutputImageKey) as! CIImage, scale: 1.0, orientation: UIImageOrientation.Up)
		}
	}
	
	internal func insertCaptionWithText(text:String) {
		
		let label = PhotoLabel()
		label.text = text
		label.sizeToFit()
		label.center = center
		addSubview(label)
	}
	
}
