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
    
    let messageText = UITextView()
    let usernameField = UITextField()
    let passwordField = UITextField()
    let submitBtn = UIButton.buttonWithType(.System) as! UIButton
    var projects = [Project]()
    
    override func viewWillAppear(animated: Bool) {
        self.messageText.text = ""
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
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addLoginForm() {
        let offset = CGFloat(20)
        let width = self.view.frame.width - CGFloat(2 * offset)
        let height = CGFloat(50)
        self.messageText.frame = CGRectMake(offset, 50, width, height)
        self.messageText.text = ""
        
        self.usernameField.frame = CGRectMake(offset, 100, width, height)
        self.usernameField.placeholder = "Username"
        self.usernameField.returnKeyType = UIReturnKeyType.Next
        self.usernameField.delegate = self
//        if count(self.usernameField.text) == 0 {
//             self.usernameField.becomeFirstResponder()
//        }
        
        self.passwordField.frame = CGRectMake(offset, 150, width, height)
        self.passwordField.placeholder = "Password"
        self.passwordField.secureTextEntry = true
        self.passwordField.delegate = self
        
        self.submitBtn.frame = CGRectMake(offset, 200, width, height)
        self.submitBtn.setTitle("Submit", forState: .Normal)
        self.submitBtn.addTarget(self, action: "doLogin:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(self.messageText)
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
            self.messageText.text = "Username is required"
            self.usernameField.becomeFirstResponder()
            return false
        } else if pwCount == 0 {
            self.messageText.text = "Password is required"
            self.passwordField.becomeFirstResponder()
            return false
        } else {
            self.messageText.text = "Username and Password are required."
            self.usernameField.becomeFirstResponder()
            return false
        }
    }

    
    func doLogin(sender: AnyObject) {
        self.messageText.text = "Loading"
        if self.validateLoginForm() {
            self.doAuth(self.usernameField.text, password: self.passwordField.text)
        }
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
            self.messageText.text = "Auth success!"
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
            println("Server responded no")
        case 500...599:
            println("Server Error")
        default:
            println("There was an error with your request")
        }
        
    }
    
    func getProjects(){
        self.messageText.text = "Getting..."
        let token = self.keychain["token"]
        if token != nil {
            
            var manager = Alamofire.Manager.sharedInstance
            manager.session.configuration.HTTPAdditionalHeaders = [
                "Authorization": "JWT \(token!)"
            ]
            
            var getProjectsRequest = manager.request(Method.GET, self.projectsURL)
            
            getProjectsRequest.responseJSON(options: nil, completionHandler:projectsReceived)
        
        } else {
            println("No token")
        }
    }
    
    func projectsReceived(request:NSURLRequest, response:NSHTTPURLResponse?, data:AnyObject?, error:NSError?) -> Void {
        
        let statusCode = response!.statusCode
        // println(statusCode)
        
        switch statusCode {
        
        case 200...299:
            let jsonData = JSON(data!)
            let results = jsonData["results"]
            var newProjects = [Project]()
            for (index:String, subJSON:JSON) in results {
                let project = Project(title: subJSON["title"].string!, url: subJSON["url"].string!, id: subJSON["id"].int!)
                
                if subJSON["video_set"].array != nil {
                    project.createLectures(subJSON["video_set"].array!)
                }
                if subJSON["image"] != nil {
                    project.imageUrlString = subJSON["image"].string!
                }
                newProjects.append(project)
            }
            self.projects = newProjects
            // println(self.projects)
            // println(self.projects.count)
            self.performSegueWithIdentifier("showProjects", sender: self)
        case 400...299:
            self.messageText.text = "Error..."
        
        case 500...299:
            self.messageText.text = "Server Error..."
            
        default:
            println("No projects")
        }
        
        self.messageText.text = "Loaded..."
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showProjects" {
            let vc = segue.destinationViewController as! ProjectTableViewController
            vc.projects = self.projects
        }
        self.messageText.text = ""
    }

}

