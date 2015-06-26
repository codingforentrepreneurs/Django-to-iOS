//
//  UICommentForm.swift
//  srvup
//
//  Created by Justin Mitchel on 6/26/15.
//  Copyright (c) 2015 Coding for Entrepreneurs. All rights reserved.
//

import UIKit

class UICommentForm: UIView {

    init(parentViewController:UIViewController, textArea:UITextView, textAreaPlaceholder:String, textAreaDelegate: UITextViewDelegate, formAction:Selector){
        let frame = CGRectMake(0, 0, parentViewController.view.frame.width, parentViewController.view.frame.height)
        super.init(frame: frame)
        
        let image = UIImage(named: "pattern")
        let bgImage = UIColor(patternImage: image!)
        let bgView = UIView()
        bgView.frame = self.frame
        bgView.backgroundColor = bgImage
        bgView.layer.zPosition = -100
        bgView.userInteractionEnabled = false
        self.addSubview(bgView)
        self.backgroundColor = UIColor(red: 0, green: 88/255.0, blue: 128/255.0, alpha: 1.0)
        
        
        
        // self.backgroundColor = .greenColor()
        
        
        let topOffset = CGFloat(25)
        let xOffset = CGFloat(10)
        let spacingE = CGFloat(10)
        
        
        // title
        let label = UILabel()
        label.text = "Add new Comment"
        label.frame = CGRectMake(xOffset, topOffset + spacingE, self.frame.width - (xOffset * 2), 30)
        label.textColor = .whiteColor()
        
        
        // text area field
        
        
        textArea.editable = true
        textArea.text = textAreaPlaceholder
        textArea.delegate = textAreaDelegate
        textArea.frame = CGRectMake(xOffset, label.frame.origin.y + label.frame.height + spacingE, label.frame.width, 250)
        // submit button
        
        let submitBtn = UIButton()
        submitBtn.frame = CGRectMake(xOffset,textArea.frame.origin.y + textArea.frame.height + spacingE, textArea.frame.width, 30)
        submitBtn.setTitle("Submit", forState: UIControlState.Normal)
        submitBtn.addTarget(parentViewController, action: formAction, forControlEvents: UIControlEvents.TouchUpInside)
        submitBtn.tag = 1
        
        // cancel button
        let cancelBtn = UIButton()
        cancelBtn.frame = CGRectMake(xOffset, submitBtn.frame.origin.y + submitBtn.frame.height + spacingE, submitBtn.frame.width, 30)
        cancelBtn.setTitle("Cancel", forState: UIControlState.Normal)
        cancelBtn.addTarget(parentViewController, action: formAction, forControlEvents: UIControlEvents.TouchUpInside)
        cancelBtn.tag = 2
        self.addSubview(label)
        self.addSubview(textArea)
        self.addSubview(submitBtn)
        self.addSubview(cancelBtn)
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
}
