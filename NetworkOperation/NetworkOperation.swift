//
//  FetchSchoolsOperation.swift
//  PartyTutor
//
//  Created by Kyle Kirkland on 7/7/16.
//  Copyright © 2016 CamberCreative. All rights reserved.
//

import Foundation

public class NetworkOperation: NSOperation, NSURLSessionDataDelegate {
    
    var path: String! {
        return ""
    }
   
    var params: [String: AnyObject]?
    private var requestUrl: String!
    private var request: NSMutableURLRequest!
    private var task: NSURLSessionDataTask?
    private let incomingData = NSMutableData()
    
    public convenience init(baseUrl: String) {
        self.init()
        self.requestUrl = baseUrl + path
        
        let url = NSURL(string: self.requestUrl)
        self.request = NSMutableURLRequest(URL: url!)
        self.task = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue: nil).dataTaskWithRequest(request)
    }
    
    public convenience init(baseUrl: String, params: [String: AnyObject]?) {
        self.init(baseUrl: baseUrl)
        self.params = params
        
        if let p = params {
            let finalUrlString = p.urlString(withPath: self.requestUrl)
            let url = NSURL(string: finalUrlString)
            self.request = NSMutableURLRequest(URL: url!)
            self.requestUrl = finalUrlString
        }
        
        self.task = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue: nil).dataTaskWithRequest(request)
    }
    
    public convenience init(baseUrl: String, params: [String: AnyObject]?, httpMethod :String) {
        self.init(baseUrl: baseUrl)
        self.params = params
        
        if let p = params {
            let finalUrlString = p.urlString(withPath: self.requestUrl)
            let url = NSURL(string: finalUrlString)
            self.request = NSMutableURLRequest(URL: url!)
            self.requestUrl = finalUrlString
        }
        
        //self.request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(params!, options: [])
        self.request.HTTPMethod = httpMethod
        self.task = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue: nil).dataTaskWithRequest(request)
    }
    
    public convenience init(baseUrl: String, params: [String: AnyObject]?, httpMethod :String, authToken: String!, email: String!) {
        self.init(baseUrl: baseUrl)
        self.params = params
        
        if let p = params {
            let finalUrlString = p.urlString(withPath: self.requestUrl)
            let url = NSURL(string: finalUrlString)
            self.request = NSMutableURLRequest(URL: url!)
            self.requestUrl = finalUrlString
        }
        
        //self.request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(params!, options: [])
        self.request.setValue(authToken, forHTTPHeaderField: "X-User-Token")
        self.request.setValue(email, forHTTPHeaderField: "X-User-Email")
        self.request.HTTPMethod = httpMethod
        self.task = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue: nil).dataTaskWithRequest(request)
    }
    
    public convenience init(actualUrl: String, httpMethod: String) {
        self.init()
        
        self.requestUrl = actualUrl
        
        let url = NSURL(string: self.requestUrl)
        self.request = NSMutableURLRequest(URL: url!)
        self.request.HTTPMethod = httpMethod        
        self.task = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue: nil).dataTaskWithRequest(request)
    }
    
    var internalFinished: Bool = false
    public override var finished: Bool {
        get {
            return internalFinished
        }
        set (newAnswer) {
            willChangeValueForKey("isFinished")
            internalFinished = newAnswer
            didChangeValueForKey("isFinished")
        }
    }
    
    public override func start() {
        task?.resume()
        
    }
    
    public func processData(data: NSData) {
        
        finished = true
    }
    
    func startFetch() {
        self.task?.resume()
    }
    
    public func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveResponse response: NSURLResponse, completionHandler: (NSURLSessionResponseDisposition) -> Void) {
        if cancelled {
            finished = true
            task?.cancel()
            return
        }
        
        print(response)
        completionHandler(.Allow)
    }
    
    public func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        if cancelled {
            finished = true
            task?.cancel()
            return
        }
        
        incomingData.appendData(data)
    }
    
    public func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if cancelled {
            finished = true
            self.task?.cancel()
            return
        }
        
        if error != nil {
            finished = true
        }
        
        self.processData(self.incomingData)
    }

    

}
