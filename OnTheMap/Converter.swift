//
//  Converter.swift
//  OnTheMap
//
//  Created by Sudeep Agrawal on 11/5/16.
//  Copyright © 2016 Agrawal. All rights reserved.
//

import Foundation

class Converter
{
    //MARK : Convert a Dictionary to NSData.
    static func toNSData(requestBody : [String:AnyObject]? = nil) -> NSData
    {
        var jsonData:NSData! = nil
        do
        {
            jsonData = try NSJSONSerialization.dataWithJSONObject(requestBody!, options: NSJSONWritingOptions.PrettyPrinted)
            //print ("Request => \(jsonData)")
        }
        catch let error as NSError
        {
            print(error)
        }
        parseJSONToAnyObject(jsonData) { (result, error) in
            
        }
        return jsonData
    }
    
    //MARK : This method will convert the JSON response to a usable AnyObject.
    static func parseJSONToAnyObject(response: NSData, completionHandler: (result:AnyObject!, error:NSError?)-> Void)
    {
        var parsedResponse:AnyObject! = nil
        do
        {
            parsedResponse = try NSJSONSerialization.JSONObjectWithData(response, options: NSJSONReadingOptions.AllowFragments)
            //print("parseJSONToAnyObject :  " + parsedResponse.description)
            completionHandler(result: parsedResponse, error: nil)
        }
        catch let error as NSError
        {
            //Failure has occurred, don't return any results.
            completionHandler(result: nil, error: error)
        }
    }
}
