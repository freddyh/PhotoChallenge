//
//  CaptureButton.swift
//  PhotoChallenge
//
//  Created by Freddy Hernandez on 12/30/15.
//  Copyright © 2015 Freddy Hernandez. All rights reserved.
//

import UIKit

class CaptureButton: UIButton {

    override func drawRect(rect: CGRect) {
		
		let circlePath = UIBezierPath(arcCenter: CGPointMake(rect.midX, rect.midY), radius: rect.width / 2 - 5.0, startAngle: 0, endAngle: 6.28, clockwise: true)
		UIColor.blueColor().setStroke()
		UIColor.lightGrayColor().setFill()
		circlePath.lineWidth = 4.0
		circlePath.stroke()
		circlePath.fill()
		alpha = 0.35
    }
}
