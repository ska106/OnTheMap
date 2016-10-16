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
    
    // MARK: Singleton Pattern
    static let sharedInstance = UdacityClient()
    
    private override init()
    {
        super.init()
    }
    
    // MARK: GET
    //func taskForGETMethod(method: String, parameters: [String: AnyObject], completionHandlerForGET: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask{}
    
    // MARK : POST
    //func taskForPOSTMethod(method: String, parameters: [String: AnyObject], completionHandlerForPOST: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask{}
    
}