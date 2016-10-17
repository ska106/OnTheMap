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
    
    // MARK : Login Udacity using username and password.
    func loginWithCredentials (userName: String, password : String , completionHandler : (id:String? , error: NSError? ) ->Void )
    {
        //Create Udactiy URL
        //let loginURL = API.createURL()
        
        //Create Request Payload
        
        //Invoke API.send()
    }

    // MARK : Logout
    func logout (userName: String, completionHandler : (id:String? , error: NSError? ) ->Void )
    {
        //Create Udactiy URL
        //let loginURL = API.createURL()
        
        //Create Request Payload
        
        //Invoke API.send()
    }
    
    // MARK : Get Student Data
    func getStudentInfo (userId : String, completionHandler : (data:NSData? , error : NSError? ) -> Void)
    {
        //Create Udactiy URL
        //let loginURL = API.createURL()
        
        //Create Request Payload
        
        //Invoke API.send()
    }
}