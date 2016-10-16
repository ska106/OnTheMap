//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Sudeep Agrawal on 10/15/16.
//  Copyright © 2016 Agrawal. All rights reserved.
//

import Foundation

class ParseClient : NSObject
{
    var session = NSURLSession.sharedSession()
    
    override init()
    {
        super.init()
    }
    
    // MARK : Singleton Pattern
    class func sharedInstance() -> ParseClient
    {
        struct Singleton
        {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
}