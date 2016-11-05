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
        var jsonData:NSData
        do
        {
            jsonData = try NSJSONSerialization.dataWithJSONObject(requestBody!, options: NSJSONWritingOptions.PrettyPrinted)
            print ("Request => \(jsonData)")
        }
        catch let error as NSError
        {
            print(error)
        }
        return jsonData
    }
}
