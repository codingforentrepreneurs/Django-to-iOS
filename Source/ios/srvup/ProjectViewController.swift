//
//  ProjectViewController.swift
//  srvup
//
//  Created by Justin Mitchel on 6/15/15.
//  Copyright (c) 2015 Coding for Entrepreneurs. All rights reserved.
//

import UIKit

class ProjectViewController: UIViewController {
    var projects = [Project]()

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

        // Do any additional setup after loading the view.
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
