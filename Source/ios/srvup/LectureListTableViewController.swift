//
//  LectureListTableViewController.swift
//  srvup
//
//  Created by Justin Mitchel on 6/16/15.
//  Copyright (c) 2015 Coding for Entrepreneurs. All rights reserved.
//

import UIKit

class LectureListTableViewController: UITableViewController, UIAlertViewDelegate {
    var project: Project?
    var lectures = [Lecture]()
    var headerView = UIView()
    let user = User()
    
    override func viewWillAppear(animated: Bool) {
        user.checkToken()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        
        let image = UIImage(named: "pattern")
        let bgImage = UIColor(patternImage: image!)
        // self.view.backgroundColor = bgImage
        //rgba(0, 88, 128, 0.92)
        let bgView = UIView()
        bgView.frame = self.view.frame
        bgView.backgroundColor = bgImage
        bgView.layer.zPosition = -100
        bgView.userInteractionEnabled = false
        self.view.addSubview(bgView)
        self.view.backgroundColor = UIColor(red: 0, green: 88/255.0, blue: 128/255.0, alpha: 1.0)
        
        
        
        self.headerView.frame = CGRectMake(0, 0, self.view.frame.width, 150)
        self.headerView.backgroundColor = .blackColor()
        
        let projectImage = self.project!.image()
        if projectImage != nil {
            let imageView = UIImageView(image: projectImage!)
            imageView.frame = self.headerView.frame
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
            self.headerView.addSubview(imageView)
        } else {
            let label = UILabel(frame: self.headerView.frame)
            label.text = self.project?.title
            label.textColor = .whiteColor()
            label.textAlignment = NSTextAlignment.Center
            self.headerView.addSubview(label)
        }
        
        let des = self.project!.projectDescription
        let xOffest = CGFloat(20.0)
        let projectDesText = UITextView()
        if des != nil && des != "" {
            projectDesText.text = des!
       
            let cellFont = UIFont.systemFontOfSize(18)
            projectDesText.font = cellFont
        
            let attrString = NSAttributedString(string: projectDesText.text, attributes: [NSFontAttributeName : cellFont])
            let constraintSize = CGSizeMake(self.tableView.bounds.size.width, CGFloat(MAXFLOAT))
            let rect = attrString.boundingRectWithSize(constraintSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
        
        
            let currentHeaderViewHY = self.headerView.frame.height + self.headerView.frame.origin.y
            projectDesText.frame = CGRectMake(xOffest, currentHeaderViewHY, self.headerView.frame.width - (2 * xOffest), rect.size.height)
            projectDesText.editable = false
            projectDesText.scrollEnabled = false
            projectDesText.textColor = .whiteColor()
            projectDesText.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        
           self.headerView.addSubview(projectDesText)
           self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y, self.headerView.frame.width, self.headerView.frame.height + projectDesText.frame.height + 20)
        
         } else {
            projectDesText.text = ""
        }

        
        let shareBtn = UIButton()
        let newHeaderViewHY = self.headerView.frame.height + self.headerView.frame.origin.y
        shareBtn.frame = CGRectMake(xOffest, newHeaderViewHY, self.headerView.frame.width - (2 * xOffest), 30)
        shareBtn.backgroundColor = UIColor(red: 59/255.0, green: 89/255.0, blue: 152/255.0, alpha: 1)
        shareBtn.setTitle("Share on Facebook", forState: UIControlState.Normal)
        shareBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        shareBtn.addTarget(self, action: "openShareLink:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        self.headerView.frame = CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y, self.headerView.frame.width, self.headerView.frame.height + shareBtn.frame.height + 10)
        self.headerView.addSubview(shareBtn)
        
        
        let btn = UINavButton(title: "Back", direction: UIButtonDirection.Right, parentView: self.tableView)
        btn.addTarget(self, action: "popView:", forControlEvents: UIControlEvents.TouchUpInside)
        self.tableView.addSubview(btn)

        self.tableView.tableHeaderView = self.headerView
        
        
        if self.project != nil {
            self.lectures = self.project!.lectureSet
        }
        
        if self.lectures.count == 0 {
            let alertVew = UIAlertView(title: "Sorry, not currently available", message: "Press okay to continue", delegate: self, cancelButtonTitle: "Okay")
            alertVew.show()
            
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func openShareLink(sender:AnyObject){
        let projectSlug = self.project!.slug
        let fblink = "https://www.facebook.com/sharer/sharer.php?u="
        let baseUrlString = "http://codingforentrepreneurs.com/"
        let fullUrlString = "\(fblink)\(baseUrlString)/projects/\(projectSlug)"
        let shareUrl = NSURL(string: fullUrlString)
        
        let application = UIApplication.sharedApplication()
        application.openURL(shareUrl!)
    }
    
    func popView(sender:AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        
        // self.navigationController?.popViewControllerAnimated(true)
        // self.navigationController?.popToRootViewControllerAnimated(true)
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
        return self.lectures.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell

        cell.textLabel?.text = self.lectures[indexPath.row].title
        cell.textLabel?.textAlignment = .Center
        let sepLine = UIView()
        sepLine.frame = CGRectMake(20, cell.contentView.frame.height, self.view.frame.width - 40, 0.5)
        sepLine.backgroundColor = .grayColor()
        cell.contentView.addSubview(sepLine)
        return cell
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
        let vc = segue.destinationViewController as! VideoTableViewController
        let indexPath = self.tableView.indexPathForSelectedRow()
        let lecture = self.lectures[indexPath!.row]
        vc.lecture = lecture
    }

}
