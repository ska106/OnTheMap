//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Sudeep Agrawal on 10/15/16.
//  Copyright © 2016 Agrawal. All rights reserved.
//

import Foundation

extension UdacityClient
{
    // MARK: Constants
    struct BaseURL
    {
        static var Host = "https://www.udacity.com"
        static let API = Host + "/api"
    }
    
    // MARK: Methods
    struct Methods
    {
        static let Session = "/session"
        static let Users = "/users"
    }
    
    struct HeaderKeys
    {
        static let Accept = "Accept"
        static let ContentType = "Content-Type"
    }
    
    struct HeaderValues
    {
        static let JSON = "application/json"
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys
    {
        static let udacity = "udacity"
        static let username = "username"
        static let password = "password"
    }
    
    // MARK: JSON Response Key
    struct JSONResponseKey
    {
        static let account = "account"
        static let registered = "registered"
        static let key = "key"
        static let session = "session"
        static let id = "id"
        static let expiration = "expiration"
        
        static let user = "user"
        static let lastName = "last_name"
        static let firstName = "first_name"
        
        static let status = "status"
        static let error = "error"
        
    }
    
    // MARK: Error Messages
    struct Errors
    {
        static let loginError = "Udacity login has failed."
        static let connectionError = "Connection error."
    }
}