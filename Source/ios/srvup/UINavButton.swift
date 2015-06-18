//
//  UINavButton.swift
//  srvup
//
//  Created by Justin Mitchel on 6/18/15.
//  Copyright (c) 2015 Coding for Entrepreneurs. All rights reserved.
//

import Foundation
import UIKit


public class UINavButton: UIButton {
    init(title:String) {
        let diameter = CGFloat(50)
        let radius = diameter/2.0
        let xOffset = CGFloat(5)
        let yOffset = CGFloat(20)
        let newFrame = CGRectMake(xOffset, yOffset, diameter, diameter)
        super.init(frame: newFrame)
        
        self.setTitle(title, forState: UIControlState.Normal)
        self.backgroundColor = UIColor(red: 0/255.0, green: 88/255.0, blue: 128/255.0, alpha: 0.75)
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}