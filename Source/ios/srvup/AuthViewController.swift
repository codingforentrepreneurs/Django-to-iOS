//
//  ViewController.swift
//  srvup
//
//  Created by Justin Mitchel on 6/14/15.
//  Copyright (c) 2015 Coding for Entrepreneurs. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KeychainAccess

class AuthViewController: UIViewController {
    let authTokenUrl = "http://127.0.0.1:8000/api/auth/token/"
    let projectsURL = "http://127.0.0.1:8000/api2/projects/?format=json"
    let keychain = Keychain(service: "com.codingforentrepreneurs.srvup")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let username = "jmitchel3"
        let password = "\(123)"
        self.doAuth(username, password: password)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func doAuth(username:String, password:String) {
        let params = ["username": username, "password": password]
        var authToken = Alamofire.request(Method.POST, self.authTokenUrl, parameters: params)
        
        authToken.responseJSON(options: nil, completionHandler: authRequestIsComplete)
        
    }
    
    func authRequestIsComplete(request:NSURLRequest, response:NSHTTPURLResponse?, data:AnyObject?, error:NSError?) -> Void {
        if error != nil {
            println(error!)
        }
        let statusCode = response!.statusCode
        
        switch statusCode {
        case 200...299:
            // success: use the data
            let jsonData = JSON(data!)
            let token = jsonData["token"].string
            let user = jsonData["user"].string!
            let active = jsonData["active"].bool!
            if active {
                self.keychain["token"] = token
                self.keychain["user"] = user
            } else {
                self.keychain["token"] = nil
            }
            self.getProjects()
            
        case 400...499:
            println("Server responded no")
        case 500...599:
            println("Server Error")
        default:
            println("There was an error with your request")
        }
        
    }
    
    func getProjects(){
        let token = self.keychain["token"]
        if token != nil {
            let url = NSURL(string: self.projectsURL)
            var mutableURLRequest = NSMutableURLRequest(URL:url!)
            mutableURLRequest.setValue("JWT \(token!)", forHTTPHeaderField: "Authorization")
            mutableURLRequest.HTTPMethod = "GET"
            var manager = Alamofire.Manager.sharedInstance
        
            var getProjectsRequest = manager.request(mutableURLRequest)
        
            getProjectsRequest.responseJSON(options: nil, completionHandler:projectsReceived)
        
        } else {
            println("No token")
        }
    }
    
    func projectsReceived(request:NSURLRequest, response:NSHTTPURLResponse?, data:AnyObject?, error:NSError?) -> Void {
        
        let statusCode = response!.statusCode
        println(statusCode)
        println(data)
        
    }

}

