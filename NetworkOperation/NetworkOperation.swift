//
//  FetchSchoolsOperation.swift
//  PartyTutor
//
//  Created by Kyle Kirkland on 7/7/16.
//  Copyright © 2016 CamberCreative. All rights reserved.
//

import Foundation

open class NetworkOperation: Operation, URLSessionDataDelegate {
    
    var path: String! {
        return ""
    }
    
    var params: [String: AnyObject]?
    fileprivate var requestUrl: String!
    fileprivate var request: URLRequest!
    fileprivate var task: URLSessionDataTask?
    fileprivate let incomingData = NSMutableData()
    
    public init(baseUrl: String) {
        super.init()
        self.requestUrl = baseUrl + path
        
        let url = URL(string: self.requestUrl)
        self.request = URLRequest(url: url!)
        self.task = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil).dataTask(with: request)
    }
    
    convenience init(baseUrl: String, params: [String: AnyObject]?) {
        self.init(baseUrl: baseUrl)
        self.params = params
        
        if let p = params {
            let finalUrlString = p.urlString(withPath: self.requestUrl)
            let url = URL(string: finalUrlString)
            self.request = URLRequest(url: url!)
            self.requestUrl = finalUrlString
        }
        
        self.task = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil).dataTask(with: request)
    }
    
    convenience public init(baseUrl: String, params: [String: AnyObject]?, httpMethod :String) {
        self.init(baseUrl: baseUrl, params: params)
        
        self.request.httpMethod = httpMethod
        self.task = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil).dataTask(with: request)
    }
    
    convenience public init(baseUrl: String, params: [String: AnyObject]?, httpMethod :String, authToken: String!, client: String!, tokenType: String!, uid: String!) {
        self.init(baseUrl: baseUrl, params: params, httpMethod: httpMethod)

        self.request.setValue(authToken, forHTTPHeaderField: "access-token")
        self.request.setValue(tokenType, forHTTPHeaderField: "token-type")
        self.request.setValue(client, forHTTPHeaderField: "client")
        self.request.setValue(uid, forHTTPHeaderField: "uid")
        
        self.task = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil).dataTask(with: request)
    }
    
    public init(actualUrl: String, httpMethod: String) {
        super.init()
        
        self.requestUrl = actualUrl
        
        let url = URL(string: self.requestUrl)
        self.request = URLRequest(url: url!)
        self.request.httpMethod = httpMethod
        self.task = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil).dataTask(with: request)
    }
    
    var internalFinished: Bool = false
    override open var isFinished: Bool {
        get {
            return internalFinished
        }
        set (newAnswer) {
            willChangeValue(forKey: "isFinished")
            internalFinished = newAnswer
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override open func start() {
        task?.resume()
        
    }
    
   open func processData(_ data: Data, forResponse response: URLResponse?) {
        
        isFinished = true
    }
    
    func startFetch() {
        self.task?.resume()
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        if isCancelled {
            isFinished = true
            task?.cancel()
            return
        }
        
        completionHandler(.allow)
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if isCancelled {
            isFinished = true
            task?.cancel()
            return
        }
        
        incomingData.append(data)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if isCancelled {
            isFinished = true
            self.task?.cancel()
            return
        }
        
        if error != nil {
            isFinished = true
        }
        
        print(task.response)
        
        self.processData(self.incomingData as Data, forResponse: task.response)
    }
    
    
    
}
