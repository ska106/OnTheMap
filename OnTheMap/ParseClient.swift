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
    func setHeaders(request: NSMutableURLRequest, setJson:Bool) -> NSMutableURLRequest
    {
        if (setJson)
        {
            request.addValue(HeaderValues.JSON, forHTTPHeaderField: HeaderKeys.Accept)
            request.addValue(HeaderValues.JSON, forHTTPHeaderField: HeaderKeys.ContentType)
        }
        request.addValue(BaseURL.APIID, forHTTPHeaderField: HeaderKeys.ApplicationId)
        request.addValue(BaseURL.APIKey, forHTTPHeaderField: HeaderKeys.RestAPIKey)
        return request
    }
    
    // MARK : Based on the name of the resource, construct the API URL to be invoked.
    func getMethodURL(resourceName: String) -> NSURL
    {
        return NSURL(string: BaseURL.API + resourceName)!;
    }
    
    
    // MARK : Method overloaded :: Based on the name of the resource, construct the API URL to be invoked.
    func getMethodURL (resourceName: String, id:String) -> NSURL
    {
        return NSURL(string: BaseURL.API + resourceName + "?where=%7B%22uniqueKey%22%3A%22" + id + "%22%7D")!;
    }
    
    // MARK : Based on the name of the resource, construct the API URL to be invoked.
    func getMethodURLForPut (resourceName: String, id:String) -> NSURL
    {
        return NSURL(string: BaseURL.API + resourceName + "/" + id)!;
    }
    
    // MARK : This method forms the URL such that the app will download 100 most recent locations posted by students.
    func getMethodURLForOrderedLocations (resourceName : String) -> NSURL
    {
        return NSURL(string: BaseURL.API + resourceName + "?limit=100&order=-updatedAt" )!;
    }
    
    // MARK : Function to initiate the API call via. Task.
    func makeTaskCall (request:NSURLRequest , completionHandlerForTaskCall : (result : AnyObject? , error: NSError?) -> Void)
    {
        let session = NSURLSession.sharedSession()
        
        //Create Task
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            //Check for error
            if error == nil
            {
                //Success
                // Convert the JSON to AnyObject so that it can be mapped to the completionHandler here.
                Converter.parseJSONToAnyObject(data!, completionHandler: completionHandlerForTaskCall)
            }
            else
            {
                //Failure
                completionHandlerForTaskCall(result: nil, error: error!)
            }
        }
        task.resume()
    }
    
    //MARK : Get Student Locations
    func getStudentLocations (completionHandlerForStudentLocations: (success: Bool,errorMessage : String?)->Void)
    {
        //Initialize the Request to invoke API.
        var request = NSMutableURLRequest(URL:getMethodURLForOrderedLocations(Methods.studentLocation))
        request = setHeaders(request, setJson: false)
        makeTaskCall(request) { (result, error) in
            if error == nil
            {
                //Success
                if let results = result?.valueForKey(JSONResponseKey.results) as? [[String:AnyObject]]
                {
                    self.studentLocations = StudentInformation.getLocationsFromResults(results)
                    //print ("Number of Students Loaded : " + String(self.studentLocations.count))
                    completionHandlerForStudentLocations(success: true,errorMessage: nil)
                }
                else
                {
                    //Failure
                    completionHandlerForStudentLocations(success: false, errorMessage : Errors.UnexpectedSystemError)
                }
            }
            else
            {
                //Failure
                completionHandlerForStudentLocations(success:false, errorMessage: Errors.connectionError)
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
        var request = NSMutableURLRequest(URL:getMethodURL(Methods.studentLocation))
        request = setHeaders(request, setJson: true)
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
        var request = NSMutableURLRequest(URL:getMethodURLForPut(Methods.studentLocation, id: objectId))
        request = setHeaders(request, setJson: true)
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