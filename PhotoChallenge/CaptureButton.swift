//
//  CaptureButton.swift
//  PhotoChallenge
//
//  Created by Freddy Hernandez on 12/30/15.
//  Copyright © 2015 Freddy Hernandez. All rights reserved.
//

import UIKit

class CaptureButton: UIButton {

    override func draw(_ rect: CGRect) {
		let circlePath = UIBezierPath(arcCenter: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2 - 5.0, startAngle: 0, endAngle: 6.28, clockwise: true)
        UIColor.blue.setStroke()
        UIColor.lightGray.setFill()
		circlePath.lineWidth = 4.0
		circlePath.stroke()
		circlePath.fill()
		alpha = 0.35
    }
}
