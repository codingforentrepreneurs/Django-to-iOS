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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var rTest = Alamofire.request(Method.GET, "http://codingforentrepreneurs.com")
        rTest.responseJSON(options: nil, completionHandler: isComplete)
    }
    
    func isComplete(request:NSURLRequest, response:NSHTTPURLResponse?, data:AnyObject?, error:NSError?) -> Void {
        println(response!.statusCode)
        println(data)
        println(error)
        println(request)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

