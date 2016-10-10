//
//  Dictionary+ParamFormatter.swift
//  NetworkOperation
//
//  Created by Kyle Kirkland on 9/7/16.
//  Copyright © 2016 Kirkland Enterprises. All rights reserved.
//

import Foundation

extension Dictionary where Key: ExpressibleByStringLiteral, Value: AnyObject {
    func urlString(withPath path: String) -> String {
        var finalString = ""
        var i = 0
        for (key, value) in self {
            if i < self.count - 1 {
                finalString += "\(key)=\(value)&"
            } else {
                finalString += "\(key)=\(value)"
            }
            
            i += 1
        }
        
        return path + "/?\(finalString)"
    }
}
