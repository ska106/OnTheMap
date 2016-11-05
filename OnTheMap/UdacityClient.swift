//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Sudeep Agrawal on 10/15/16.
//  Copyright © 2016 Agrawal. All rights reserved.
//

import Foundation

class UdacityClient : NSObject
{
    var userId: String
    
    var session = NSURLSession.sharedSession()
    
    // MARK: Singleton Pattern
    static let sharedInstance = UdacityClient()
    
    private override init()
    {
        super.init()
    }
    
    // MARK : Prepare the HTTP header for the request.
    func setHeaders(request: NSMutableURLRequest) -> NSMutableURLRequest
    {
        request.addValue(HeaderValues.JSON, forHTTPHeaderField: HeaderKeys.Accept)
        request.addValue(HeaderValues.JSON, forHTTPHeaderField: HeaderKeys.ContentType)
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
    
    // MARK : Login Udacity using username and password.
    func loginWithCredentials (userName: String, password : String , completionHandler : (success:Bool,  errorMessage:String? ) ->Void )
    {
        //Create Request Payload
        var apiRequest = [String: AnyObject]()
        apiRequest[JSONBodyKeys.udacity] = [JSONBodyKeys.username:userName,JSONBodyKeys.password:password]
        
        //Initialize the Request to invoke API.
        var request = NSMutableURLRequest(URL:getMethodURL(Methods.Session))
        request.HTTPMethod = "POST"
        request = setHeaders(request)
        
        //Convert the apiRequest to NSData and assign it to request HTTP Body.
        request.HTTPBody = Converter.toNSData(apiRequest)
        
        makeTaskCall(request, completionHandler: { (result, error) in
            if error == nil
            {
                //Success
                if let account = result!.valueForKey(JSONResponseKey.account) as? NSDictionary
                {
                    if let userId = account.valueForKey(JSONResponseKey.key) as? String
                    {
                        self.userId = userId
                        // Get User Info based on the user ID above.
                     
                        completionHandler(success: true,errorMessage: nil)
                    }
                    else
                    {
                        //Failure when not able to get the user id in the response.
                        completionHandler(success:false,errorMessage: Errors.loginError)
                    }
                }
                else
                {
                    //Failure when not able to get a key in the response.
                    completionHandler(success:false,errorMessage: Errors.loginError)
                }
            }
            else
            {
                //Failure becuase not able to connect to the API
                completionHandler(success:false,errorMessage: Errors.connectionError)
            }
        })
    }

    // MARK : Logout
    func logout (userName: String, completionHandler : (id:String? , error: NSError? ) ->Void )
    {
        //Create Udactiy URL
        //let loginURL = API.createURL()
        
        //Create Request Payload
        
        //Invoke API.send()
    }
    
    // MARK : Get Student Data
    func getStudentInfo (userId : String, completionHandler : (data:NSData? , error : NSError? ) -> Void)
    {
        //Create Request Payload
        
        //Invoke API.send()
    }
}