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

class AuthViewController: UIViewController, UITextFieldDelegate {
    let authTokenUrl = "http://127.0.0.1:8000/api/auth/token/"
    let projectsURL = "http://127.0.0.1:8000/api2/projects/?format=json"
    let keychain = Keychain(service: "com.codingforentrepreneurs.srvup")
    
   
    let activityLoader = UIActivityIndicatorView()
    let usernameField = UITextField()
    let passwordField = UITextField()
    let submitBtn = UIButton.buttonWithType(.System) as! UIButton
    var projects = [Project]()
    
    override func viewWillAppear(animated: Bool) {
        self.passwordField.text = ""
        
        let username = self.keychain["user"]
        
        if username != nil {
            self.usernameField.text = username
            self.passwordField.becomeFirstResponder()
        } else {
            self.usernameField.becomeFirstResponder()
        }
        
        let token = self.keychain["token"]
        if token != nil {
            let url = NSURL(string: self.projectsURL)
            var mutRequest = NSMutableURLRequest(URL: url!)
            mutRequest.setValue("JWT \(token!)", forHTTPHeaderField: "Authorization")
            mutRequest.HTTPMethod = "GET"
            
            var manager = Alamofire.Manager.sharedInstance
            
            var checkRequest = manager.request(mutRequest)
            checkRequest.response({ (request, response, data, error) -> Void in
                let statusCode = response?.statusCode
                // println(statusCode)
                if statusCode == 200 {
                    self.getProjects()
                } else {
                    self.keychain["token"] = nil
                    self.viewWillAppear(false)
                }
            })
            
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.addLoginForm()
        self.navigationController?.navigationBarHidden = true
        let image = UIImage(named: "pattern")
        let bgImage = UIColor(patternImage: image!)
        let bgView = UIView()
        bgView.frame = self.view.frame
        bgView.backgroundColor = bgImage
        bgView.layer.zPosition = -100
        bgView.userInteractionEnabled = false
        self.view.addSubview(bgView)
        self.view.backgroundColor = UIColor(red: 0, green: 88/255.0, blue: 128/255.0, alpha: 1.0)
        
        self.activityLoader.center = self.view.center
        self.view.addSubview(self.activityLoader)
        
         let brandLabel = UILabel()
        brandLabel.text = "srvup"
        brandLabel.textColor = .whiteColor()
        brandLabel.font = UIFont.boldSystemFontOfSize(26)
        brandLabel.frame = CGRectMake(0, 50, self.view.frame.width, 40)
        brandLabel.textAlignment = .Center
        
        self.view.addSubview(brandLabel)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addLoginForm() {
        let offset = CGFloat(20)
        let width = self.view.frame.width - CGFloat(2 * offset)
        let height = CGFloat(50)
        // self.messageText.frame = CGRectMake(offset, 50, width, height)
        // self.messageText.text = ""
        
        
        
        self.usernameField.frame = CGRectMake(offset, 100, width, height)
        self.usernameField.placeholder = "Username"
        self.usernameField.returnKeyType = UIReturnKeyType.Next
        self.usernameField.backgroundColor = .whiteColor()
        self.usernameField.delegate = self
//        if count(self.usernameField.text) == 0 {
//             self.usernameField.becomeFirstResponder()
//        }
        self.usernameField.textAlignment = .Center
        
        self.passwordField.frame = CGRectMake(offset, self.usernameField.frame.origin.y + height + 2.5, width, height)
        self.passwordField.placeholder = "Password"
        self.passwordField.secureTextEntry = true
        self.passwordField.delegate = self
        self.passwordField.backgroundColor = .whiteColor()
        self.passwordField.textAlignment = .Center
        
        
        self.submitBtn.frame = CGRectMake(offset, self.passwordField.frame.origin.y + height + 15, width, height)
        self.submitBtn.setTitle("Login", forState: .Normal)
        self.submitBtn.addTarget(self, action: "doLogin:", forControlEvents: UIControlEvents.TouchUpInside)
        self.submitBtn.backgroundColor = .whiteColor()
        
        self.view.addSubview(self.usernameField)
        self.view.addSubview(self.passwordField)
        self.view.addSubview(self.submitBtn)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == self.usernameField) {
            self.passwordField.becomeFirstResponder()
        } else if (textField == self.passwordField) {
            self.doLogin(self.submitBtn)
        } else {
            
        }
        return true
    }
    
    func validateLoginForm() -> Bool {
        let unCount = count(self.usernameField.text)
        let pwCount = count(self.passwordField.text)
        if (unCount > 0) && (pwCount > 0) {
            return true
        } else if unCount == 0 {
            Notification().notify("Username is required", delay: 2.5, inSpeed: 0.7, outSpeed: 1.2)
            self.usernameField.becomeFirstResponder()
            return false
        } else if pwCount == 0 {
            Notification().notify("Password is required", delay: 2.5, inSpeed: 0.7, outSpeed: 1.2)
            self.passwordField.becomeFirstResponder()
            return false
        } else {
             Notification().notify("Username and password are required", delay: 2.5, inSpeed: 0.7, outSpeed: 1.2)
            self.usernameField.becomeFirstResponder()
            return false
        }
    }

    
    func doLogin(sender: AnyObject) {
        // self.messageText.text = "Loading"
        if self.validateLoginForm() {
            self.doAuth(self.usernameField.text, password: self.passwordField.text)
        }
    }
    
    func doAuth(username:String, password:String) {
        let params = ["username": username, "password": password]
        var authToken = Alamofire.request(Method.POST, self.authTokenUrl, parameters: params)
        self.activityLoader.startAnimating()
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
            // println(jsonData)
            let token = jsonData["token"].string
            let user = jsonData["user"].string!
            let userid = jsonData["userid"].string!
            let active = jsonData["active"].bool!
            if active {
                self.keychain["token"] = token
                self.keychain["user"] = user
                self.keychain["userid"] = userid
            } else {
                self.keychain["token"] = nil
            }
            self.getProjects()
            
        case 400...499:
            let jsonData = JSON(data!)
            let errorArray = jsonData["non_field_errors"].array
            var currentString = ""
            if errorArray != nil {
                for i in errorArray! {
                    currentString = currentString + "\(i)"
                }
            }
            Notification().notify(currentString, delay: 2.5, inSpeed: 0.7, outSpeed: 1.2)
            // println("Server responded no \(currentString)")
        case 500...599:
            Notification().notify("Server Error. Please try again later", delay: 2.5, inSpeed: 0.7, outSpeed: 1.2)
        default:
            Notification().notify("There was an error with your request. Please try again later", delay: 2.5, inSpeed: 0.7, outSpeed: 1.2)

        }
        
        self.activityLoader.stopAnimating()
        
    }
    
    func getProjects(){
        let token = self.keychain["token"]
        if token != nil {
            
            var manager = Alamofire.Manager.sharedInstance
            manager.session.configuration.HTTPAdditionalHeaders = [
                "Authorization": "JWT \(token!)"
            ]
            
            var getProjectsRequest = manager.request(Method.GET, self.projectsURL)
            self.activityLoader.startAnimating()
            getProjectsRequest.responseJSON(options: nil, completionHandler:projectsReceived)
            
        } else {
            println("No token")
        }
    }
    
    func projectsReceived(request:NSURLRequest, response:NSHTTPURLResponse?, data:AnyObject?, error:NSError?) -> Void {
        
        let statusCode = response!.statusCode
        
        switch statusCode {
        
        case 200...299:
            let jsonData = JSON(data!)
            let results = jsonData["results"]
            var newProjects = [Project]()
            for (index:String, subJSON:JSON) in results {
                let project = Project(title: subJSON["title"].string!, url: subJSON["url"].string!, id: subJSON["id"].int!, slug: subJSON["slug"].string!)
                
                if subJSON["video_set"].array != nil {
                    project.createLectures(subJSON["video_set"].array!)
                }
                if subJSON["image"] != nil {
                    project.imageUrlString = subJSON["image"].string!
                }
                
                if subJSON["description"] != nil {
                    project.projectDescription = subJSON["description"].string!
                }
                newProjects.append(project)
            }
            self.projects = newProjects
            self.performSegueWithIdentifier("showProjects", sender: self)
        case 400...299:
             Notification().notify("Loading Error. Please try again later", delay: 2.5, inSpeed: 0.7, outSpeed: 1.2)
            
        case 500...299:
            Notification().notify("Server Error. Please try again later", delay: 2.5, inSpeed: 0.7, outSpeed: 1.2)
            
        default:
            Notification().notify("There was an error with your request. Please try again later", delay: 2.5, inSpeed: 0.7, outSpeed: 1.2)
        }
        self.activityLoader.stopAnimating()
        
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showProjects" {
            let vc = segue.destinationViewController as! ProjectTableViewController
            vc.projects = self.projects
        }
    }

}

