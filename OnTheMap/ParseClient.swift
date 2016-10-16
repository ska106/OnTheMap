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
    
    //Singleton Pattern
    static let sharedInstance = ParseClient()
    
    private override init()
    {
        super.init()
    }
}