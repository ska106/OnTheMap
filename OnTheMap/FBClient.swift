//
//  FBClient.swift
//  OnTheMap
//
//  Created by Sudeep Agrawal on 10/15/16.
//  Copyright © 2016 Agrawal. All rights reserved.
//

import Foundation

class FBClient : NSObject
{
    var session = NSURLSession.sharedSession()
    
    override init()
    {
        super.init()
    }
    
    // MARK : Singleton Pattern
    class func sharedInstance() -> FBClient
    {
        struct Singleton
        {
            static var sharedInstance = FBClient()
        }
        return Singleton.sharedInstance
    }
}