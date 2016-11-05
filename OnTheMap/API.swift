//
//  API.swift
//  OnTheMap
//
//  Created by Sudeep Agrawal on 10/16/16.
//  Copyright © 2016 Agrawal. All rights reserved.
//

import Foundation

class API
{
    private let session : NSURLSession
    
    // MARK : All supported HTTP methods.
    enum RestHTTPMethod:String
    {
        case GET
        case POST
        case DELETE
        case PUT
    }
 
    // MARK: Singleton Pattern
    static let sharedInstance = API()
    
    private init()
    {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        self.session = NSURLSession(configuration: configuration)
    }
    
    //MARK : send method will actually invoke the REST API call.
    func send(url:NSURL, restHTTPMethod: RestHTTPMethod, HTTPHeaders:[String:String]!, requestBody:[String:AnyObject]? = nil, responseHandler: (NSData? , NSError?) -> Void )
    {
        //Set the URL
        let sessionRequest = NSMutableURLRequest(URL: url)
        //Set the HTTP method
        sessionRequest.HTTPMethod = restHTTPMethod.rawValue
        
        //Add Header keys to the Session Request
        if let HTTPHeaders = HTTPHeaders
        {
            for (headerKey, headerValue) in HTTPHeaders
            {
                sessionRequest.addValue(headerValue, forHTTPHeaderField: headerKey)
            }
        }
        
        //Add Request Body to the Session Request by converting input dictionary to JSON Object.
        //Ref: StackOverflow: Convert Dictionary to JSON in SWIFT.
    
        if requestBody != nil
        {
            do
            {
                let jsonData = try NSJSONSerialization.dataWithJSONObject(requestBody!, options: NSJSONWritingOptions.PrettyPrinted)
                print ("Request => \(jsonData)")
                sessionRequest.HTTPBody = jsonData
            }
            catch let error as NSError
            {
                print(error)
            }
        }
        
        //Create Task
        let task = session.dataTaskWithRequest(sessionRequest) { (data, response, error) in
            
            //Check for error
            if let error = error
            {
                print (error)
                responseHandler(nil,error)
                return
            }
            
            responseHandler(data,nil)
        }
        task.resume()
    }
}