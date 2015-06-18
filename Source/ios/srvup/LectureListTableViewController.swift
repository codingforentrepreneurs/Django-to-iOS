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

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    func popView(sender:AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        self.dismissViewControllerAnimated(true, completion: nil)
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

        return cell
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
        let vc = segue.destinationViewController as! VideoViewController
        let indexPath = self.tableView.indexPathForSelectedRow()
        let lecture = self.lectures[indexPath!.row]
        vc.lecture = lecture
    }

}
