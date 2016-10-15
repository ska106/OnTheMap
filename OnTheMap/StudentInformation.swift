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
    init(arg:NSDictionary)
    {
        self.objectId = arg["objectId"] as! String
        self.uniqueId = arg["uniqueId"] as! String
        self.firstName = arg["firstName"] as! String
        self.lastName = arg["lastName"] as! String
        self.mapString = arg["mapString"] as! String
        self.mediaURL = arg["mediaURL"] as! String
        self.longitude = arg["longitude"] as! Double
        self.latitude = arg["latitude"] as! Double
    }
}