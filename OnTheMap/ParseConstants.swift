//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Sudeep Agrawal on 10/15/16.
//  Copyright © 2016 Agrawal. All rights reserved.
//

import Foundation

extension ParseClient
{
    // MARK: Constants
    struct BaseURL
    {
        static let APIKey : String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let APIID : String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        // Old URL : https://api.parse.com/1/classes
        static let BaseURL : String = "http://parse.udacity.com/parse/classes"
    }
    
    // MARK: Methods
    struct Methods
    {
        static let studentLocation = "/StudentLocation"
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
        static let objectId = "objectId"
        static let uniqueKey = "uniqueKey"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let createdAt = "createdAt"
        static let updatedAt = "updatedAt"
    }
    
    // MARK: Error Messages
    struct Errors
    {
        static let loginError = "Udacity login has failed."
        static let connectionError = "Connection error."
    }

}