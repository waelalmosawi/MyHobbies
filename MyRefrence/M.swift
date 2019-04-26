//
//  M.swift
//  MyHobbies
//
//  Created by Wael on 3/29/19.
//  Copyright © 2019 Wael. All rights reserved.
//
import UIKit
class UITextViewPadding : UIImageView {

    private weak var borderLayer: CAShapeLayer?
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // create path
        let rec = CGRect(x: 0, y: 0, width: 181, height: 136)
        //let width = min(bounds.width, bounds.height)
        let path = UIBezierPath(roundedRect:rec, cornerRadius: 25)
        
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
