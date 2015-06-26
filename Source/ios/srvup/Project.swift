//
//  Project.swift
//  srvup
//
//  Created by Justin Mitchel on 6/15/15.
//  Copyright (c) 2015 Coding for Entrepreneurs. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import KeychainAccess
import SwiftyJSON

class Project:NSObject {
    var title:String
    var url:String
    var id:Int
    var slug:String
    var projectDescription: String?
    var imageUrlString: String?
    // var videoSet = [JSON]()
    var lectureSet = [Lecture]()
    
    init(title:String, url:String, id:Int, slug:String) {
        self.title = title
        self.url = url
        self.id = id
        self.slug = slug
    }
    
    func image() -> UIImage? {
        if self.imageUrlString != nil {
            let url = NSURL(string: self.imageUrlString!)!
            let imageData = NSData(contentsOfURL: url)!
            let image = UIImage(data: imageData)
            return image
        }
        
        return nil
    }
    
    func createLectures(theArray:[JSON]) {
        if self.lectureSet.count == 0 && theArray.count > 0 {
            for i in theArray {
                var lecture = Lecture(title: i["title"].string!, url: i["url"].string!, id: i["id"].int!, slug: i["slug"].string!, order: i["order"].int!, embedCode: i["embed_code"].string!)
                
                lecture.shareMessage = i["share_message"].string
                lecture.timestamp = i["timestamp"].string
                if i["comment_set"].array != nil {
                    lecture.commentSet = i["comment_set"].array!
                }
                if i["free_preview"].bool != nil {
                    lecture.freePreview = i["free_preview"].bool!
                }
                self.lectureSet.append(lecture)
            }
        }
        
    }
    
}

class Lecture: NSObject {
    var title: String
    var url: String
    var id: Int
    var slug: String
    var order: Int
    var embedCode: String
    var freePreview = false
    var shareMessage: String?
    var timestamp: String?
    var commentSet = [JSON]()
    
    init(title:String, url:String, id:Int, slug:String, order:Int, embedCode:String) {
        self.title = title
        self.url = url
        self.id = id
        self.slug = slug
        self.order = order
        self.embedCode = embedCode
    }
    func updateLectureComments(completion:(success:Bool)->Void){
        let keychain = Keychain(service: "com.codingforentrepreneurs.srvup")
        let token = keychain["token"]
        if token != nil {
            var manager = Alamofire.Manager.sharedInstance
            manager.session.configuration.HTTPAdditionalHeaders = [
                "Authorization": "JWT \(token!)"
            ]
            let getCommentsRequest = manager.request(Method.GET, self.url, parameters:nil, encoding: ParameterEncoding.JSON)
            getCommentsRequest.responseJSON(options: nil, completionHandler: { (request, response, data, error) -> Void in
                let statusCode = response?.statusCode
                if (200 ... 299 ~= statusCode!) && (data != nil) {
                    let jsonData = JSON(data!)
                    let commentSet = jsonData["comment_set"].array
                    if commentSet != nil {
                        self.commentSet = commentSet!
                    }

                    completion(success: true)
                } else {
                    completion(success: false)
                    
                }
            })
            
            
            
        } else {
            println("No token")
        }
        
    }
    func addComment(commentText:String, parent:Int?, completion:(success:Bool, dataSent:JSON?)->Void){
        let commentCreateUrlString = "http://127.0.0.1:8000/api2/comment/create/"
        let keychain = Keychain(service: "com.codingforentrepreneurs.srvup")
        let token = keychain["token"]
        let user = keychain["user"]
        let userid = keychain["userid"]
        if token != nil && userid != nil {
            var manager = Alamofire.Manager.sharedInstance
            manager.session.configuration.HTTPAdditionalHeaders = [
                "Authorization": "JWT \(token!)"
            ]
            
            var params = ["text" : commentText, "video": "\(self.id)", "user": "\(userid!)"]
            
            if parent != nil {
                params = ["text" : commentText, "video": "\(self.id)", "user": "\(userid!)", "parent": "\(parent!)"]
            }
            
            let addCommentRequest = manager.request(Method.POST, commentCreateUrlString, parameters:params, encoding: ParameterEncoding.JSON)
            println(self.commentSet.count)
            addCommentRequest.responseJSON(options: nil, completionHandler: { (request, response, data, error) -> Void in
                let statusCode = response?.statusCode
                
                // 201
                println(response)
                println(data)
                println(error)
                if (200 ... 299 ~= statusCode!) && (data != nil) {
                    let jsonData = JSON(data!)
                    self.commentSet.insert(jsonData, atIndex: 0)
                    // self.commentSet.append(jsonData)
                    let newData = ["text": "\(commentText)", "user":"\(user!)"]
                    completion(success: true, dataSent:JSON(newData))
                } else {
                    completion(success: false, dataSent:nil)
                    
                }
            })
            
        
            
        } else {
            println("No token")
        }
    }
    
    
    
}