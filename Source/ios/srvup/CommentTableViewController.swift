//
//  CommentTableViewController.swift
//  srvup
//
//  Created by Justin Mitchel on 6/23/15.
//  Copyright (c) 2015 Coding for Entrepreneurs. All rights reserved.
//

import UIKit

class CommentTableViewController: UITableViewController {
    var lecture: Lecture?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let headerView = UITextView()
        headerView.frame = CGRectMake(0, 0, self.view.frame.width, 75)
        headerView.text = "\(self.lecture!.title) \nComments"
        headerView.textColor = .blackColor()
        headerView.backgroundColor = .whiteColor()
        headerView.textAlignment = .Center
        headerView.font = UIFont.boldSystemFontOfSize(24)
        self.tableView.tableHeaderView = headerView

        let footerView = UITextView()
        footerView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        footerView.text = "Add New Comment"
        footerView.textColor = .blackColor()
        footerView.backgroundColor = .redColor()
        footerView.textAlignment = .Center
        footerView.font = UIFont.boldSystemFontOfSize(24)
        
        let backTopBtn = UIButton()
        backTopBtn.frame = CGRectMake(10, 50, self.view.frame.width - 20, 50)
        backTopBtn.setTitle("BackToTop", forState: UIControlState.Normal)
        backTopBtn.addTarget(self, action: "backToTop:", forControlEvents: UIControlEvents.TouchUpInside)
        footerView.addSubview(backTopBtn)
        
        
        self.tableView.tableFooterView = footerView
        
        
        let btn = UINavButton(title: "Back", direction: .Right, parentView: self.view)
        btn.addTarget(self, action: "popView:", forControlEvents: UIControlEvents.TouchUpInside)
        btn.frame.origin.y = btn.frame.origin.y - 10
        self.view.addSubview(btn)
        
        let newCommentBtn = UINavButton(title: "New", direction: .Left, parentView: self.view)
        newCommentBtn.addTarget(self, action: "scrollToFooter:", forControlEvents: UIControlEvents.TouchUpInside)
        newCommentBtn.frame.origin.y = btn.frame.origin.y
        self.view.addSubview(newCommentBtn)
        
    }
    
    func backToTop(sender:AnyObject) {
        self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
    }
    
    func scrollToFooter(sender:AnyObject) {
        let lastRowItem = self.lecture!.commentSet.count - 1
        let section = 0
      self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: lastRowItem, inSection: section), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
