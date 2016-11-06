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
        udClient = UdacityClient.sharedInstance
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.password.text = ""
    }
    
    @IBAction func loginUdacity(sender: AnyObject)
    {
        udClient.loginWithCredentials(email.text!, password: password.text!) { (success, errorMessage) in
            if (success)
            {
                //TODO : Move to the next Tab
            }
            else
            {
                //TODO: Stay on the same page and display error message on the login page.
                if error == UdacityClient.Errors.loginError
                {
                    
                }
                
            }
            
        }
    }
    
    // MARK : Functions to call Udacity API for login.
    
    private func getRequestToken(){}

    private func loginWithToken(requestToken : String){}
    
    private func getSessionId(requestToken : String){}
    
    private func getUserId(sessionId : String){}
}