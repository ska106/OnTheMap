//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Sudeep Agrawal on 10/16/16.
//  Copyright © 2016 Agrawal. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController : UIViewController
{
    // MARK : Properties
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var udacityLoginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var udClient : UdacityClient!
    
    // MARK : LifeCycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Get the singleton instances of the API clients.
        udClient = UdacityClient.sharedInstance
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.activityIndicator.hidden = true
        self.email.text=""
        self.password.text = ""
    }
    
    @IBAction func tapUdacitySignup(sender: AnyObject)
    {
        UIApplication.sharedApplication().openURL(NSURL(string:UdacityClient.BaseURL.Host)!)
    }
    
    @IBAction func loginUdacity(sender: AnyObject)
    {
        print(">>> loginUdacity ")
        self.loginStartActivity(true)
        udClient.loginWithCredentials(email.text!, password: password.text!) { (success, errorMessage) in
            print ("In loginWithCredentials completionHandler ")
            if (success)
            {
                dispatch_async(dispatch_get_main_queue())
                {
                    //Login Activity has been completed.
                    self.loginStartActivity(false)
                    //Move to  - OnTheMapTabBarContoller
                    self.performSegueWithIdentifier("ToTabController", sender: self)
                }
            }
            else
            {
                //TODO: Stay on the same page and display error message.
                if errorMessage == UdacityClient.Errors.loginError
                {
                    print (errorMessage)
                }
                
                dispatch_async(dispatch_get_main_queue())
                {
                    self.loginStartActivity(false)
                }
            }
        }
    }
    
    // MARK : Function to let user know that login process has started.
    func loginStartActivity(started:Bool) -> Void
    {
        udacityLoginButton.hidden = started
        email.userInteractionEnabled = !started
        password.userInteractionEnabled = !started
        activityIndicator.hidden = !started
        if (started)
        {
            activityIndicator.startAnimating()
        }
        else
        {
            activityIndicator.stopAnimating()
        }
    }
}