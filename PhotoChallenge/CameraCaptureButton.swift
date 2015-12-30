//
//  CameraCaptureButton.swift
//  PhotoChallenge
//
//  Created by Freddy Hernandez on 12/30/15.
//  Copyright © 2015 Freddy Hernandez. All rights reserved.
//

import UIKit

class CameraCaptureButton: UIButton {

	
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
		
		let circlePath = UIBezierPath(arcCenter: CGPointMake(rect.midX, rect.midY), radius: rect.width / 2, startAngle: 0, endAngle: 6.28, clockwise: true)
		UIColor.redColor().setStroke()
		UIColor.lightGrayColor().setFill()
		circlePath.lineWidth = 3.0
		circlePath.stroke()
		circlePath.fill()
		alpha = 0.35
    }
	

}
