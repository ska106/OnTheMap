//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Sudeep Agrawal on 10/15/16.
//  Copyright © 2016 Agrawal. All rights reserved.
//

import Foundation

class ParseClient : NSObject
{
    var session = NSURLSession.sharedSession()
    
    //Singleton Pattern
    static let sharedInstance = ParseClient()
    
    private override init()
    {
        super.init()
    }
    
    // MARK : Prepare the HTTP header for the request.
    func setHeaders(request: NSMutableURLRequest) -> NSMutableURLRequest
    {
        request.addValue(HeaderValues.JSON, forHTTPHeaderField: HeaderKeys.Accept)
        request.addValue(HeaderValues.JSON, forHTTPHeaderField: HeaderKeys.ContentType)
        request.addValue(BaseURL.APIID, forHTTPHeaderField: HeaderKeys.ApplicationId)
        request.addValue(BaseURL.APIKey, forHTTPHeaderField: HeaderKeys.RestAPIKey)
        return request
    }
    
    // MARK : Based on the name of the resource, construct the API URL to be invoked.
    func getMethodURL (resourceName: String) -> NSURL
    {
        return NSURL(fileURLWithPath: BaseURL.API + resourceName);
    }
    
    // MARK : Function to initiate the API call via. Task.
    func makeTaskCall (request:NSURLRequest , completionHandler : (result : AnyObject? , error: NSError?) -> Void) -> NSURLSessionTask
    {
        let session = NSURLSession.sharedSession()
        
        //Create Task
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            //Check for error
            if error == nil
            {
                //Success
                let newData = data?.subdataWithRange(NSMakeRange(5, (data?.length)! - 5)) //Subset response data - based on Udacity security standards.
                // Convert the JSON to AnyObject so that it can be mapped to the completionHandler here.
                Converter.parseJSONToAnyObject(newData!, completionHandler: completionHandler)
                completionHandler(result:newData , error: nil)
            }
            else
            {
                //Failure
                completionHandler(result: nil, error: error!)
            }
        }
        task.resume()
        return task
    }
    
    
    
    
    // MARK: GET
    //func taskForGETMethod(method: String, parameters: [String: AnyObject], completionHandlerForGET: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask{}
    
    // MARK : POST
    //func taskForPOSTMethod(method: String, parameters: [String: AnyObject], completionHandlerForPOST: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask{}
}