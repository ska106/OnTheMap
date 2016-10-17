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
    struct Constants
    {
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
        static let AuthorizationURL : String = "https://www.themoviedb.org/authenticate/"
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
        static let Udacity = "udacity"
        static let username = "username"
        static let password = "password"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys
    {
        
    }
    
    // MARK: Error Messages
    struct Errors
    {
        static let FailedToParseJSON = "Failed to parse JSON Body"
    }
}