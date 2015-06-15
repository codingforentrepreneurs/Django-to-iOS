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

class ViewController: UIViewController {
    let authTokenUrl = "http://127.0.0.1:8000/api/auth/token/"
    let keychain = Keychain(service: "com.codingforentrepreneurs.srvup")
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let params = ["username": "jmitchel3", "password": 123]
        var rTest = Alamofire.request(Method.POST, self.authTokenUrl, parameters: params)
        
        rTest.responseJSON(options: nil, completionHandler: isComplete)
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
            
            // println(self.keychain["token"])
            
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

