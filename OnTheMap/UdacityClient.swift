//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Sudeep Agrawal on 10/15/16.
//  Copyright © 2016 Agrawal. All rights reserved.
//

import Foundation

class UdacityClient
{
    var userObjectId: String?
    var userFirstName: String = ""
    var userLastName: String = ""
    
    var session = NSURLSession.sharedSession()
    
    // MARK: Singleton Pattern
    static let sharedInstance = UdacityClient()
    
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
        return NSURL(string: BaseURL.API + resourceName)!;
    }
    
    // MARK : Function to initiate the API call via. Task.
    func makeTaskCall (request:NSURLRequest , completionHandlerForTaskCall : (result : AnyObject? , error: NSError?) -> Void)
    {
        
        //print("In MakeTaskCall request - " + request.description)
        let session = NSURLSession.sharedSession()
        
        //Create Task
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            //print("In dataTaskWithRequest Completionhandler")
            //Check for error
            if error == nil
            {
                //Success
                //print("MakeTaskCall.Success")
                let newData = data?.subdataWithRange(NSMakeRange(5, (data?.length)! - 5)) //Subset response data - based on Udacity security standards.
                // Convert the JSON to AnyObject so that it can be mapped to the completionHandler here.
                Converter.parseJSONToAnyObject(newData!, completionHandler: completionHandlerForTaskCall)
            }
            else
            {
                //Failure
                completionHandlerForTaskCall(result: nil, error: error!)
            }
        }
        task.resume()
    }
    
    // MARK : Login Udacity using username and password.
    func loginWithCredentials (userName: String, password : String , completionHandlerForLogin : (success:Bool,  errorMessage:String? ) ->Void )
    {
        //print(">>> loginWithCredentials")
        //Create Request Payload
        var apiRequest = [String: AnyObject]()
        apiRequest[JSONBodyKeys.udacity] = [JSONBodyKeys.username:userName,JSONBodyKeys.password:password]
        
        //Initialize the Request to invoke API.
        var request = NSMutableURLRequest(URL:getMethodURL(Methods.Session))
        request.HTTPMethod = "POST"
        request = setHeaders(request)
        
        //Convert the apiRequest to NSData and assign it to request HTTP Body.
        request.HTTPBody = Converter.toNSData(apiRequest)
        
        makeTaskCall(request, completionHandlerForTaskCall: { (result, error) in
            
            //print("In makeTaskCall Completion Handler")
            if error == nil
            {
                //Success
                // Step 1. Get the Account Node.
                if let account = result!.valueForKey(JSONResponseKey.account) as? NSDictionary
                {
                    //Step 2. Parse out the Key Node (aka user-ID)
                    if let userId = account.valueForKey(JSONResponseKey.key) as? String
                    {
                        self.userObjectId = userId
                        //print("UserID : " + userObjectId!)
                        
                        // Get User Info based on the user ID above.
                        self.getStudentInfo(userId, completionHandlerForStudentInfo: { (success, errorMessage) in
                            if (success)
                            {
                                //print ("\n User Full Name =  \(userFirstName) \(userLastName)")
                                completionHandlerForLogin(success: true, errorMessage: nil)
                            }
                            else
                            {
                                //print("\n")
                                print (error)
                                completionHandlerForLogin(success: false, errorMessage: Errors.connectionError)
                            }
                        })
                    }
                    else
                    {
                        //Failure when not able to get the user id in the response.
                        completionHandlerForLogin(success:false,errorMessage: Errors.loginError)
                    }
                }
                else
                {
                    //Failure when not able to get a key in the response.
                    completionHandlerForLogin(success:false,errorMessage: Errors.loginError)
                }
            }
            else
            {
                //Failure because not able to connect to the API
                completionHandlerForLogin(success:false,errorMessage: Errors.connectionError)
            }
        })
    }

    // MARK : Udacity Logout
    func logout (completionHandler : (success:Bool,  errorMessage:String? ) ->Void )
    {
        //Initialize the Request to invoke API.
        let request = NSMutableURLRequest(URL:getMethodURL(Methods.Session))
        request.HTTPMethod = "DELETE"
        var xsrfCookie:NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies!
        {
            if cookie.name == "XSRF-TOKEN"
            {
                xsrfCookie = cookie
            }
            if let xsrfCookie = xsrfCookie
            {
                request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
            }
        }
        makeTaskCall(request) { (result, error) in
            if error == nil
            {
                //Success
                completionHandler(success: true, errorMessage: nil)
            }
            else
            {
                completionHandler(success:false,errorMessage: Errors.connectionError)
            }
        }
    }
    
    // MARK : Get Student Data
    func getStudentInfo (userId : String, completionHandlerForStudentInfo : (success:Bool,  errorMessage:String? ) ->Void)
    {
        //print(">>> UdacityClient.getStudentInfo")
        //Initialize the Request to invoke API.
        var request = NSMutableURLRequest(URL:getMethodURL(Methods.Users+"/"+userId))
        request.HTTPMethod = "GET"
        request = setHeaders(request)
        
        makeTaskCall(request) { (result, error) in
            //print ("GetStudentForResult" + (result?.description)!)
            if error == nil
            {
                //Success
                //Step 1. Get the user node.
                if let user = result!.valueForKey(JSONResponseKey.user) as? NSDictionary
                {
                    //Step 2. Parse out the first name of the user object.
                    if let fName = user.valueForKey(JSONResponseKey.firstName) as? String
                    {
                        self.userFirstName = fName
                    }
                    //Step 3. Parse out the last name of the user object.
                    if let lName = user.valueForKey(JSONResponseKey.lastName) as? String
                    {
                        self.userLastName = lName
                    }
                    //print("Student Name : \(userFirstName) \(userLastName)")
                    completionHandlerForStudentInfo(success: true, errorMessage: nil)
                }
            }
            else
            {
                completionHandlerForStudentInfo(success:false,errorMessage: Errors.connectionError)
            }
         }
    }
}