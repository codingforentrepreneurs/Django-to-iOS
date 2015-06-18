//
//  VideoViewController.swift
//  srvup
//
//  Created by Justin Mitchel on 6/17/15.
//  Copyright (c) 2015 Coding for Entrepreneurs. All rights reserved.
//

import UIKit

class VideoViewController: UIViewController {
    var lecture: Lecture?
    var webView = UIWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        let label = UILabel()
        label.frame = CGRectMake(0, 30, self.view.frame.width, 50)
        
        if self.lecture != nil {
            let webViewWidth = self.view.frame.width - 20
            let webViewVideoHeight = 275
            let embedCode = lecture!.embedCode
            let cssCode = "<style>body{padding:0px;margin:0px;}iframe{width:\(webViewWidth);height:\(webViewVideoHeight);}</style>"
            let htmlCode = "<html>\(cssCode)<body><h1>\(self.lecture!.title)</h1>\(embedCode)</body></html>"
            self.webView.frame = CGRectMake(10, 50, webViewWidth, 375)
            let url = NSURL(string: "http://codingforentrepreneurs.com")
            self.webView.loadHTMLString(htmlCode, baseURL: url)
            self.webView.scrollView.bounces = false
            self.webView.backgroundColor = .whiteColor()
            
            
        }
            // self.view.addSubview(label)
        
        let btn = UINavButton(title: "Back", direction: .Right, parentView: self.view)
        btn.addTarget(self, action: "popView:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(self.webView)
        self.view.addSubview(btn)
        // Do any additional setup after loading the view.
    }
    
    func popView(sender:AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
       self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
