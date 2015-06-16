//
//  ProjectViewController.swift
//  srvup
//
//  Created by Justin Mitchel on 6/15/15.
//  Copyright (c) 2015 Coding for Entrepreneurs. All rights reserved.
//

import UIKit

class ProjectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var projects = [Project]()
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        let titleText = UILabel(frame: CGRectMake(0, 0, self.view.frame.width, 100))
        titleText.text = "Projects - \(self.projects.count)"
        titleText.textAlignment = NSTextAlignment.Center
        
        self.view.addSubview(titleText)
        
        if self.projects.count > 0 {
            for i in projects {
                println(i.title)
            }
        }
        
        self.tableView.frame = CGRectMake(0, self.view.frame.height/4.0, self.view.frame.width, self.view.frame.height * 3/4.0)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)

        // Do any additional setup after loading the view.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = "\(indexPath.row + 1) - \(self.projects[indexPath.row].title)"
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.projects.count
    }
    
    // numberOfRowsInSection
    
    
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
