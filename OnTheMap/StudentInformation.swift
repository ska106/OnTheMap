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
    var objectId : String?
    var uniqueId : String?
    var firstName : String?
    var lastName : String?
    var mapString : String?
    var mediaURL : String?
    var longitude : Double?
    var latitude : Double?
    var fullname : String {return "\(firstName!) \(lastName!)"}
    
    //As per the rubic cube the struct must have an init method that accepts a dictionary as an argument.
    init(parseResult: [String:AnyObject])
    {
        objectId = parseResult["objectId"] as? String
        uniqueId = parseResult["uniqueKey"] as? String
        firstName = parseResult["firstName"] as? String
        lastName = parseResult["lastName"] as? String
        mapString = parseResult["mapString"] as? String
        mediaURL = parseResult["mediaURL"] as? String
        longitude = parseResult["longitude"] as? Double
        latitude = parseResult["latitude"] as? Double
    }
    
    //MARK : This method will convert the dictionary of StudentInformation into an Array of StudentInformation, which will later be used in creating the pins
    //       in the map kit and the datasource in the ListView page.
    
    static func getLocationsFromResults(results: [[String:AnyObject]]) -> [StudentInformation]
    {
        var returnLocations = [StudentInformation]()
        for result in results
        {
            if !StudentInformation.studentHasNilValues(StudentInformation(parseResult: result))
            {
                returnLocations.append(StudentInformation(parseResult: result))
            }
        }
        return returnLocations
    }
    
    //MARK : This method will filter out those records that have a nil value for objectId, latitude, and longitude. There data records are considered as garbage
    //       as they are unusable to be displayed as a unique pin on the map.
    static func studentHasNilValues(studentInfo:StudentInformation) -> Bool
    {
        var hasNil:Bool = false
        if  studentInfo.latitude == nil ||
            studentInfo.longitude == nil ||
            studentInfo.objectId == nil
        {
            ////print("Nil Value Found, record must be rejected.")
            hasNil = true
        }
        return hasNil
    }
    
    
}