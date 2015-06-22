//
//  VideoViewController.swift
//  srvup
//
//  Created by Justin Mitchel on 6/17/15.
//  Copyright (c) 2015 Coding for Entrepreneurs. All rights reserved.
//

import UIKit

class VideoViewController: UIViewController, UITextViewDelegate {
    var lecture: Lecture?
    var webView = UIWebView()
    var commentView = UIView()
    var message = UITextView()
    let textArea = UITextView()
    
    let textAreaPlaceholder = "Your comment here..."
    
    let user = User()
    
    override func viewWillAppear(animated: Bool) {
        user.checkToken()
    }
    
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
        
        
        let addFormBtn = UINavButton(title: "New", direction: .Right, parentView: self.view)
        addFormBtn.frame = CGRectMake(btn.frame.origin.x, btn.frame.origin.y + btn.frame.height + 5, btn.frame.width, btn.frame.height)
        addFormBtn.addTarget(self, action: "newComment:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(self.webView)
        self.view.addSubview(btn)
         self.view.addSubview(addFormBtn)
        // Do any additional setup after loading the view.
    }
    
    func newComment(sender:AnyObject){
        self.commentView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        self.commentView.backgroundColor = .blackColor()
        self.view.addSubview(self.commentView)
        
        let topOffset = CGFloat(25)
        let xOffset = CGFloat(10)
        let spacingE = CGFloat(10)
        
        // response message
        self.message.editable = false
        self.message.frame = CGRectMake(xOffset, topOffset, self.commentView.frame.width - (2 * xOffset), 30)
        self.message.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0)
        self.message.textColor = .redColor()
        
        // title
        let label = UILabel()
        label.text = "Add new Comment"
        label.frame = CGRectMake(xOffset, self.message.frame.origin.y + self.message.frame.height + spacingE, self.message.frame.width, 30)
        label.textColor = .whiteColor()

        
        // text area field
        
        self.textArea.editable = true
        self.textArea.text = self.textAreaPlaceholder
        self.textArea.delegate = self
        self.textArea.frame = CGRectMake(xOffset, label.frame.origin.y + label.frame.height + spacingE, label.frame.width, 250)
        // submit button
        
        let submitBtn = UIButton()
        submitBtn.frame = CGRectMake(xOffset, self.textArea.frame.origin.y + self.textArea.frame.height + spacingE, self.textArea.frame.width, 30)
        submitBtn.setTitle("Submit", forState: UIControlState.Normal)
        submitBtn.addTarget(self, action: "commentFormAction:", forControlEvents: UIControlEvents.TouchUpInside)
        submitBtn.tag = 1
        
        // cancel button
        let cancelBtn = UIButton()
        cancelBtn.frame = CGRectMake(xOffset, submitBtn.frame.origin.y + submitBtn.frame.height + spacingE, submitBtn.frame.width, 30)
        cancelBtn.setTitle("Cancel", forState: UIControlState.Normal)
        cancelBtn.addTarget(self, action: "commentFormAction:", forControlEvents: UIControlEvents.TouchUpInside)
        cancelBtn.tag = 2
        
        self.commentView.addSubview(label)
        self.commentView.addSubview(self.message)
        self.commentView.addSubview(self.textArea)
        self.commentView.addSubview(submitBtn)
        self.commentView.addSubview(cancelBtn)
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        self.message.text = ""
        if textView.text == self.textAreaPlaceholder {
            textView.text = ""
        }
    }

    
    func commentFormAction(sender: AnyObject) {
        let tag = sender.tag
        
        switch tag {
        case 1:
            if self.textArea.text != "" && self.textArea.text != self.textAreaPlaceholder {
                self.textArea.endEditing(true)
                self.lecture!.addComment(self.textArea.text, completion: addCommentCompletionHandler)
            } else {
                self.message.text = "A comment is required."
            }
        default:
            println("cancelled")
            self.commentView.removeFromSuperview()

        }
    }
    
    func addCommentCompletionHandler(success:Bool) -> Void {
        if !success {
            // not successful comment so the new comment view again
            self.newComment(self)
        } else {
            self.commentView.removeFromSuperview()
        }
    }
    
    
    func popView(sender:AnyObject) {
       self.navigationController?.popViewControllerAnimated(true)
       // self.dismissViewControllerAnimated(true, completion: nil)
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
