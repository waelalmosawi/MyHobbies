//
//  RoundedImageView.swift
//  MYHob
//
//  Created by Wael on 3/11/19.
//  Copyright © 2019 Wael. All rights reserved.
//
import UIKit

@IBDesignable
class RoundedImageView: UIImageView {
    
    /// saved rendition of border layer
    
    private weak var borderLayer: CAShapeLayer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // create path
        
        let width = min(bounds.width, bounds.height)
        let path = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: width / 2, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        
        // update mask and save for future reference
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
        
        // create border layer
        
        let frameLayer = CAShapeLayer()
        frameLayer.path = path.cgPath
        frameLayer.lineWidth = 0
        frameLayer.strokeColor = UIColor.white.cgColor
        frameLayer.fillColor = nil
        
        // if we had previous border remove it, add new one, and save reference to new one
        
        borderLayer?.removeFromSuperlayer()
        layer.addSublayer(frameLayer)
        borderLayer = frameLayer
    }
}
