//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Sudeep Agrawal on 10/15/16.
//  Copyright © 2016 Agrawal. All rights reserved.
//

import Foundation

class UdacityClient : NSObject
{
    var session = NSURLSession.sharedSession()
    
    //Singleton Pattern
    static let sharedInstance = UdacityClient()
    
    private override init()
    {
        super.init()
    }
}