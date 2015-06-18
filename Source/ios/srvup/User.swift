//
//  User.swift
//  srvup
//
//  Created by Justin Mitchel on 6/18/15.
//  Copyright (c) 2015 Coding for Entrepreneurs. All rights reserved.
//

import UIKit
import Alamofire
import KeychainAccess

class User: NSObject {
    let projectsURL = "http://127.0.0.1:8000/api2/projects/?format=json"
    let keychain = Keychain(service: "com.codingforentrepreneurs.srvup")
    
    func checkToken() {
        let token = self.keychain["token"]
        if token != nil {
            let url = NSURL(string: self.projectsURL)
            var mutableURLRequest = NSMutableURLRequest(URL:url!)
            mutableURLRequest.setValue("JWT \(token!)", forHTTPHeaderField: "Authorization")
            mutableURLRequest.HTTPMethod = "GET"
            var manager = Alamofire.Manager.sharedInstance
            
            var getProjectsRequest = manager.request(mutableURLRequest)
            
            getProjectsRequest.response({ (request, response, data, error) -> Void in
                let statusCode = response?.statusCode
                if statusCode != 200 {
                    self.logoutUser()
                }
            })
            
        } else {
            println("No token")
        }
        
        
    }
    
    func logoutUser() {
        self.keychain["token"] = nil
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let navController = appDelegate.window!.rootViewController as! UINavigationController
        
        navController.popToRootViewControllerAnimated(true)
        
    }
   
}
