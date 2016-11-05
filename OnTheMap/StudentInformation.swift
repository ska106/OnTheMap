//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Sudeep Agrawal on 10/15/16.
//  Copyright © 2016 Agrawal. All rights reserved.
//

import Foundation

// As per the rubic evaluation all the student infomration must be stored in this struct
struct StudentInformation
{
    //Following are the parameters that uniquely represent a single student from the ParseDB : StudentLocation.
    var objectId : String!
    var uniqueId : String!
    var firstName : String!
    var lastName : String!
    var mapString : String!
    var mediaURL : String!
    var longitude : Double!
    var latitude : Double!
    
    //As per the rubic cube the struct must have an init method that accepts a dictionary as an argument.
    init(parseResult: [String:AnyObject])
    {
        self.objectId = parseResult["objectId"] as! String
        self.uniqueId = parseResult["uniqueId"] as! String
        self.firstName = parseResult["firstName"] as! String
        self.lastName = parseResult["lastName"] as! String
        self.mapString = parseResult["mapString"] as! String
        self.mediaURL = parseResult["mediaURL"] as! String
        self.longitude = parseResult["longitude"] as! Double
        self.latitude = parseResult["latitude"] as! Double
    }
    
    static func getLocationsFromResults(results: [[String:AnyObject]]) -> [StudentInformation]
    {
        var returnLocations = [StudentInformation]()
        for result in results
        {
            returnLocations.append(StudentInformation(parseResult: result))
        }
        return returnLocations
    }
}