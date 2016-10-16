//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Sudeep Agrawal on 10/15/16.
//  Copyright © 2016 Agrawal. All rights reserved.
//

import Foundation

extension ParseClient {
    
    // MARK: Constants
    struct Constants
    {
        // MARK: API Key
        static let ApiKey : String = "YOUR_API_KEY_HERE"
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "api.themoviedb.org"
        static let ApiPath = "/3"
        static let AuthorizationURL : String = "https://www.themoviedb.org/authenticate/"
    }
    
    // MARK: Methods
    struct Methods
    {
        
    }
    
    // MARK: URL Keys
    struct URLKeys
    {
        static let UserID = "id"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys
    {
        
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys
    {
        
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys
    {
        
    }
}