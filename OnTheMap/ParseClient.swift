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
    var studentLocations : [StudentInformation]
    //Singleton Pattern
    static let sharedInstance = ParseClient()
    
    private override init()
    {
        studentLocations = [StudentInformation]()
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
    func getMethodURL(resourceName: String) -> NSURL
    {
        return NSURL(fileURLWithPath: BaseURL.API + resourceName);
    }
    
    
    // MARK : Method overloaded :: Based on the name of the resource, construct the API URL to be invoked.
    func getMethodURL (resourceName: String, id:String) -> NSURL
    {
        return NSURL(fileURLWithPath: BaseURL.API + resourceName + "?where=%7B%22uniqueKey%22%3A%22" + id + "%22%7D");
    }
    
    // MARK : Based on the name of the resource, construct the API URL to be invoked.
    func getMethodURLForPut (resourceName: String, id:String) -> NSURL
    {
        return NSURL(fileURLWithPath: BaseURL.API + resourceName + "/" + id);
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
                // Convert the JSON to AnyObject so that it can be mapped to the completionHandler here.
                Converter.parseJSONToAnyObject(data!, completionHandler: completionHandler)
                completionHandler(result:data , error: nil)
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
    
    //MARK : Get Student Locations
    func getStudentLcoation (completionHandler: (success: Bool,errorMessage : String?)->Void)
    {
        //Initialize the Request to invoke API.
        let request = NSMutableURLRequest(URL:getMethodURL(Methods.studentLocation))
        //request.HTTPMethod = "GET"
        makeTaskCall(request) { (result, error) in
            if error == nil
            {
                //Success
                if let results = result?.valueForKey(JSONResponseKey.results) as? [[String:AnyObject]]
                {
                    self.studentLocations = StudentInformation.getLocationsFromResults(results)
                    completionHandler(success: true,errorMessage: nil)
                }
                else
                {
                    //Failure
                    completionHandler(success: false, errorMessage : Errors.UnexpectedSystemError)
                }
            }
            else
            {
                //Failure
                completionHandler(success:false, errorMessage: Errors.connectionError)
            }
        }
    }
    
    //MARK : Find a student Location by a uniqueId - corresponding to a Student Location record.
    func findStudentLocation (uniqueKey : String, completionHandler: (success:Bool, errorMessage: String?) -> Void)
    {
        //Initialize the Request to invoke API.
        let request = NSMutableURLRequest(URL:getMethodURL(Methods.studentLocation,id: uniqueKey))
        //request.HTTPMethod = "GET"
        makeTaskCall(request) { (result, error) in
            if error == nil
            {
                //Success
                if let results = result?.valueForKey(JSONResponseKey.results) as? [[String:AnyObject]]
                {
                    self.studentLocations = StudentInformation.getLocationsFromResults(results)
                    completionHandler(success: true,errorMessage: nil)
                }
                else
                {
                    //Failure
                    completionHandler(success: false, errorMessage : Errors.UnexpectedSystemError)
                }
            }
            else
            {
                //Failure
                completionHandler(success:false, errorMessage: Errors.connectionError)
            }
        }
    }
    
    //MARK : Post a Student Location
    func postStudentLocation (studentData: [String:AnyObject], completionHandler:(success: Bool, errorMessage  : String?) -> Void)
    {
        //Initialize the Request to invoke API.
        let request = NSMutableURLRequest(URL:getMethodURL(Methods.studentLocation))
        request.HTTPMethod = "POST"
        request.HTTPBody = Converter.toNSData(studentData)
        makeTaskCall(request) { (result, error) in
            if error == nil
            {
                //Success
                completionHandler(success: true, errorMessage: nil)
            }
            else
            {
                //Failure
                completionHandler(success:false, errorMessage: Errors.UnexpectedSystemError)
            }
        }
    }
    
    //MARK : Update a Student Location
    func updateStudentLocation (objectId: String, studentData : [String:AnyObject], completionHandler:(success: Bool, errorMessage: String?) -> Void)
    {
        //Initialize the Request to invoke API.
        let request = NSMutableURLRequest(URL:getMethodURLForPut(Methods.studentLocation, id: objectId))
        request.HTTPMethod = "PUT"
        request.HTTPBody = Converter.toNSData(studentData)
        makeTaskCall(request) { (result, error) in
            if error == nil
            {
                //Success
                completionHandler(success: true, errorMessage: nil)
            }
            else
            {
                //Failure
                completionHandler(success:false, errorMessage: Errors.UnexpectedSystemError)
            }
        }
    }
}