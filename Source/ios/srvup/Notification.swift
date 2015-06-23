//
//  Notification.swift
//  srvup
//
//  Created by Justin Mitchel on 6/23/15.
//  Copyright (c) 2015 Coding for Entrepreneurs. All rights reserved.
//

import UIKit

public class Notification: NSObject {
   
    func notify(message:String, delay:Double, inSpeed:Double, outSpeed:Double) {
        let notification = UIView()
        let notificationText = UITextView()
        let application = UIApplication.sharedApplication()
        let window = application.keyWindow!
        self.fadeIn(notification, speed: inSpeed)
        notification.frame = CGRectMake(0, 0, window.frame.width, 50)
        notification.backgroundColor = .redColor()
        notification.addSubview(notificationText)
        notificationText.frame = CGRectMake(0, 0, notification.frame.width, 30)
        notificationText.frame.origin.y = (notification.frame.height - notificationText.frame.height)/2.0
        notificationText.text = message
        notificationText.textAlignment = .Center
        notificationText.font = UIFont.systemFontOfSize(18.0)
        notificationText.textColor = .whiteColor()
        notificationText.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0)
        
        window.addSubview(notification)
        
        let seconds = delay
        let delayNanoSeconds = seconds * Double(NSEC_PER_SEC)
        let now = DISPATCH_TIME_NOW
        var theTimeToDispatch = dispatch_time(now, Int64(delayNanoSeconds))
        
        dispatch_after(theTimeToDispatch, dispatch_get_main_queue()) { () -> Void in
            self.fadeOut(notification, speed:outSpeed)
            // self.notification.removeFromSuperview()
        }
    }
    
    func fadeIn(theView:UIView, speed:Double) {
        theView.alpha = 0
        UIView.animateWithDuration(speed, animations: { () -> Void in
            theView.alpha = 1
        })
    }
    
    func fadeOut(theView:UIView, speed:Double) {
        UIView.animateWithDuration(speed, animations: { () -> Void in
            theView.alpha = 0
        })
        
    }

    
    
}
