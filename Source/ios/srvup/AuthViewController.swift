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
    
    let tokenUse = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImptaXRjaGVsMyIsInVzZXJfaWQiOjEsImVtYWlsIjoiY29kaW5nZm9yZW50cmVwcmVuZXVyc0BnbWFpbC5jb20iLCJleHAiOjE0MzQ0MDgwNzJ9.5EvVwnrPwhSXrZtwTSwe-Bhs6vqPV_c4HZfqXoYc3iw"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let params = ["username": "jmitchel3", "password": 123]
        
        
        
        let url = NSURL(string: self.projectsURL)
        var mutableURLRequest = NSMutableURLRequest(URL:url!)
        mutableURLRequest.setValue("JWT \(self.tokenUse)", forHTTPHeaderField: "Authorization")
        mutableURLRequest.HTTPMethod = "GET"
        var manager = Alamofire.Manager.sharedInstance
        
        var getProjects = manager.request(mutableURLRequest)
        
        getProjects.responseJSON(options: nil, completionHandler:projectsReceived)
        
        
//        var authToken = Alamofire.request(Method.POST, self.authTokenUrl, parameters: params)
//        
//        authToken.responseJSON(options: nil, completionHandler: isComplete)
    }
    
    func projectsReceived(request:NSURLRequest, response:NSHTTPURLResponse?, data:AnyObject?, error:NSError?) -> Void {
        
        let statusCode = response!.statusCode
        println(statusCode)
        println(data)
        
    }
    
    func isComplete(request:NSURLRequest, response:NSHTTPURLResponse?, data:AnyObject?, error:NSError?) -> Void {
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
            
            println(self.keychain["token"])
            
        case 400...499:
            println("Server responded no")
        case 500...599:
            println("Server Error")
        default:
            println("There was an error with your request")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

