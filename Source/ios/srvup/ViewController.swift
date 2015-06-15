//
//  ViewController.swift
//  srvup
//
//  Created by Justin Mitchel on 6/15/15.
//  Copyright (c) 2015 Coding for Entrepreneurs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.someFunc("Justin", age: nil, completionHandler: isComplete)
        self.newFunc(newCompletionH)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func someFunc(name:String, age:Int?, completionHandler:(isDone:Bool)-> Void) -> String {
        println("hello there \(name)")
        
        completionHandler(isDone: true)
        return "hello there \(name)"
    }
    
    func isComplete(done:Bool) -> Void {
        println(done)
    }
    
    func newFunc(completionHandler:()->Void) {
        completionHandler()
    }
    
    func newCompletionH() -> Void {
        println("new one has ran")
    }
    

}
