//
//  Project.swift
//  srvup
//
//  Created by Justin Mitchel on 6/15/15.
//  Copyright (c) 2015 Coding for Entrepreneurs. All rights reserved.
//

import Foundation


class Project:NSObject {
    var title:String
    var url:String
    var id:Int
    var slug:String?
    var projectDescription: String?
    var imageUrl: String?
    // var videoSet = Array?
    
    init(title:String, url:String, id:Int) {
        self.title = title
        self.url = url
        self.id = id
    }
    
}