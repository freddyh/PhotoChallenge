//
//  CaptionableImageView.swift
//  PhotoChallenge
//
//  Created by Freddy Hernandez on 1/3/16.
//  Copyright © 2016 Freddy Hernandez. All rights reserved.
//

import UIKit

class CaptionableImageView: UIImageView {

	var originalImage: UIImage!
	private var filterIndex:Int = -1
//    let allFilters = ["CIComicEffect", "CIColorInvert", "CIColorPosterize", "CIPhotoEffectChrome", "CIPhotoEffectFade", "CIPhotoEffectInstant", "CIPhotoEffectMono", "CIPhotoEffectNoir", "CIPhotoEffectProcess", "CIPhotoEffectTonal", "CIPhotoEffectTransfer", "CISepiaTone", "CICrystallize", "CIEdges", "CIEdgeWork", "CIHexagonalPixellate"]
//    let allFilters = CIFilter.filterNames(inCategory: kCICategoryStillImage)
    let allFilters = CIFilter.filterNames(inCategory: kCICategoryStillImage).filter {
        // make sure these filters have the keys that i will be using
        if let filter = CIFilter.init(name: $0) {
            let hasInputImage = filter.inputKeys.contains(kCIInputImageKey)
            let hasOutputImage = filter.outputKeys.contains(kCIOutputImageKey)
            return hasInputImage && hasOutputImage
        } else {
            return false
        }
    }
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
        isUserInteractionEnabled = true
        
        let swipeLeftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(CaptionableImageView.updateFilterIndex))
        swipeLeftRecognizer.direction = .left
		swipeLeftRecognizer.numberOfTouchesRequired = 1
		swipeLeftRecognizer.delegate = self
		
        let swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(CaptionableImageView.updateFilterIndex))
        swipeRightRecognizer.direction = .right
		swipeRightRecognizer.numberOfTouchesRequired = 1
		swipeRightRecognizer.delegate = self
		
		addGestureRecognizer(swipeLeftRecognizer)
		addGestureRecognizer(swipeRightRecognizer)
	}
	
	var currentImage: UIImage {
		get {
			UIGraphicsBeginImageContextWithOptions(frame.size, true, 0)
            drawHierarchy(in: bounds, afterScreenUpdates: true)
			let result = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
			
            return result!
		}
	}
	
    @objc func updateFilterIndex(sender:UISwipeGestureRecognizer) {
		
		
		switch sender.direction {
        case .right:
			if filterIndex == -1 {
				filterIndex = allFilters.count - 1
			} else {
				filterIndex -= -1
			}
        case .left:
			if filterIndex == allFilters.count - 1 {
				filterIndex = -1
			} else {
				filterIndex += 1
			}
		default:
            break
		}
		
		updateImageWithFilter()
	}
	
	func updateImageWithFilter() {
		
		if filterIndex == -1 {
			image = originalImage!
		} else {
			let filterName = allFilters[filterIndex]
            let ciImage = CIImage(image: originalImage!)!
            if let stillImageFilter = CIFilter(name: filterName, parameters: [kCIInputImageKey: ciImage]) {
                if (filterName == "CIColorCubesMixedWithMask") {
                    print("todo: why does this filter crash me")
                    return
                }
                stillImageFilter.setDefaults()
                print("filter succeeded: \(filterName)")
                
                if let outputImage = stillImageFilter.outputImage {
                    print("extent: \(outputImage.extent)")
                    let cropped = outputImage.cropped(to: ciImage.extent)
                    image = UIImage(ciImage: cropped, scale: 1.0, orientation: UIImage.Orientation.up)
                } else {
                    print("there was no valid output image")
                }
                
            } else {
                print("filter failed: \(filterName)")
            }
		}
	}
	
	func insertCaptionWithText(text:String) {
		
		let label = PhotoLabel()
		label.text = text
        label.frame = CGRect(x: 0, y: 0, width: (self.superview?.bounds.width)!, height: 60)
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
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		

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
