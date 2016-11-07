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
        self.email.text=""
        self.password.text = ""
    }
    
    @IBAction func loginUdacity(sender: AnyObject)
    {
        udClient.loginWithCredentials(email.text!, password: password.text!) { (success, errorMessage) in
            if (success)
            {
                //Move to  - OnTheMapTabBarContoller
                let controller = self.storyboard!.instantiateViewControllerWithIdentifier("OnTheMapTabBarController") as! UITabBarController
                self.presentViewController(controller, animated: true, completion: nil)
            }
            else
            {
                //TODO: Stay on the same page and display error message on the login page.
                if errorMessage == UdacityClient.Errors.loginError
                {
                    print (errorMessage)
                }
            }
            
        }
    }
}