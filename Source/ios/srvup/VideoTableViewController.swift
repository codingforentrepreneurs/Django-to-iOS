//
//  VideoTableViewController.swift
//  srvup
//
//  Created by Justin Mitchel on 6/23/15.
//  Copyright (c) 2015 Coding for Entrepreneurs. All rights reserved.
//

import UIKit
import SwiftyJSON

class VideoTableViewController: UITableViewController , UITextViewDelegate {
    var lecture: Lecture?
    var webView = UIWebView()
    var message = UITextView()
    let textArea = UITextView()
    let textAreaPlaceholder = "Your comment here..."
    let aRefeshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btn = UINavButton(title: "Back", direction: .Right, parentView: self.view)
        btn.addTarget(self, action: "popView:", forControlEvents: UIControlEvents.TouchUpInside)
        btn.frame.origin.y = btn.frame.origin.y - 10
        self.view.addSubview(btn)
        
        let newCommentBtn = UINavButton(title: "New", direction: .Left, parentView: self.view)
        newCommentBtn.addTarget(self, action: "scrollToFooter:", forControlEvents: UIControlEvents.TouchUpInside)
        newCommentBtn.frame.origin.y = btn.frame.origin.y
        self.view.addSubview(newCommentBtn)
        
        let headerView = UIView()
        headerView.frame = CGRectMake(0, 0, self.view.frame.width, 395)
        headerView.backgroundColor = .whiteColor()
        
        
        
        let headerTextView = UITextView()
        headerTextView.frame = CGRectMake(0, btn.frame.origin.y, self.view.frame.width, btn.frame.height)
        headerTextView.text = "\(self.lecture!.title)"
        headerTextView.textColor = .blackColor()
        headerTextView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        headerTextView.textAlignment = .Center
        headerTextView.font = UIFont.boldSystemFontOfSize(26)
        headerTextView.editable = false
        headerTextView.scrollEnabled = false
        
        headerView.addSubview(headerTextView)
        
        self.tableView.tableHeaderView = headerView
        
        // self.tableView.tableFooterView = self.addContactForm()
        // self.textArea.delegate = self
        let commentForm = UICommentForm(parentViewController: self, textArea: self.textArea, textAreaPlaceholder: self.textAreaPlaceholder, textAreaDelegate:self, formAction: "commentFormAction:")
        self.tableView.tableFooterView = commentForm
        
        
        self.aRefeshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.aRefeshControl.addTarget(self, action: "updateItems:", forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(self.aRefeshControl)
        
        
        
    
        let webViewWidth = self.view.frame.width - 20
        let webViewVideoHeight = 275
        let embedCode = lecture!.embedCode
        let cssCode = "<style>body{padding:0px;margin:0px;}iframe{width:\(webViewWidth);height:\(webViewVideoHeight);}</style>"
        let htmlCode = "<html>\(cssCode)<body>\(embedCode)</body></html>"
        self.webView.frame = CGRectMake(10, 75, webViewWidth, 275)
        let url = NSURL(string: "http://codingforentrepreneurs.com")
        self.webView.loadHTMLString(htmlCode, baseURL: url)
        self.webView.scrollView.bounces = false
        self.webView.backgroundColor = .whiteColor()
        
        let commentLabel = UILabel()
        commentLabel.frame = CGRectMake(self.webView.frame.origin.x, self.webView.frame.origin.y + self.webView.frame.height + 10, self.webView.frame.width, 50)
        commentLabel.text = "Comments"
        commentLabel.font = UIFont.boldSystemFontOfSize(16)
        
        headerView.addSubview(commentLabel)
        headerView.addSubview(self.webView)
        
        
    }
    
    func updateItems(sender:AnyObject) {
        self.lecture?.updateLectureComments({ (success) -> Void in
            if success {
                println("grabbed comment successfully")
                self.aRefeshControl.endRefreshing()
                self.tableView.reloadData()
            } else {
                Notification().notify("Error updated data", delay: 2.0, inSpeed: 0.7, outSpeed: 2.5)
                self.aRefeshControl.endRefreshing()
            }
        })
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
                self.lecture!.addComment(self.textArea.text, parent:nil, completion: addCommentCompletionHandler)
                self.textArea.text = self.textAreaPlaceholder
            } else {
                self.message.text = "A comment is required."
            }
        default:
            // println("cancelled")
            // self.commentView.removeFromSuperview()
            self.backToTop(self)
            
        }
    }
    
    func addCommentCompletionHandler(success:Bool, dataSent:JSON?) -> Void {
        if !success {
            self.scrollToFooter(self)
            Notification().notify("Failed to add", delay: 2.5, inSpeed: 0.7, outSpeed: 1.2)
            
        } else {
            Notification().notify("Message Added", delay: 1.5, inSpeed: 0.5, outSpeed: 1.0)
            self.scrollToTop({ (success) -> Void in
                if success{
                    self.tableView.reloadData()
                }
            })
            
        }
    }
    
    

    
    func backToTop(sender:AnyObject) {
        self.scrollToTop { (success) -> Void in
        }
    }
    
     // MARK: Scroll to Functions
    
    func scrollToTop(completion:(success:Bool) -> Void){
        let point = CGPoint(x: 0, y: -10)
        self.tableView.setContentOffset(point, animated: true)
        completion(success: true)
    }
    
    
    func scrollToFooter(sender:AnyObject) {
        let point = CGPoint(x: 0, y: self.tableView.tableFooterView!.frame.origin.y)
        self.tableView.setContentOffset(point, animated: true)
    }
    
    func popView(sender:AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        // self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.lecture!.commentSet.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        // Configure the cell...
        let text = self.lecture!.commentSet[indexPath.row]["text"].string!
        let user = self.lecture!.commentSet[indexPath.row]["user"].string
        let children = self.lecture!.commentSet[indexPath.row]["children"].array
        var responses = 0
        if children != nil {
            responses = children!.count
        }
        var newText = ""
        if user != nil {
            newText = "\(text) \n\n via \(user!) - \(responses) Responses"
        } else {
            newText = "\(text)"
        }
        
        cell.textLabel?.text = newText
        cell.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let text = self.lecture!.commentSet[indexPath.row]["text"].string!
        let user = self.lecture!.commentSet[indexPath.row]["user"].string
        let children = self.lecture!.commentSet[indexPath.row]["children"].array
        var responses = 0
        if children != nil {
            responses = children!.count
        }
        var newText = ""
        if user != nil {
            newText = "\(text) \n\n via \(user!) - \(responses) Responses"
        } else {
            newText = "\(text)"
        }
        
        let cellFont = UIFont.boldSystemFontOfSize(14)
        let attrString = NSAttributedString(string: newText, attributes: [NSFontAttributeName : cellFont])
        let constraintSize = CGSizeMake(self.tableView.bounds.size.width, CGFloat(MAXFLOAT))
        let rect = attrString.boundingRectWithSize(constraintSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
        
        return rect.size.height + 50
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showCommentResponses" {
            let vc = segue.destinationViewController as! ResponseTableViewController
            let indexPath = self.tableView.indexPathForSelectedRow()!
            
            let text = self.lecture!.commentSet[indexPath.row]["text"].string!
            let user = self.lecture!.commentSet[indexPath.row]["user"].string
            let children = self.lecture!.commentSet[indexPath.row]["children"].array
            let commentID = self.lecture!.commentSet[indexPath.row]["id"].int!
            
            vc.commentText = text
            vc.commentUser = user
            if children != nil {
                vc.commentChidren = children!
            }
            vc.lecture = self.lecture!
            vc.commentID = commentID
            
            
        }
    }
    
    
}
