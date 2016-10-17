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
    
    @IBAction func loginUdacity(sender: AnyObject)
    {
        
    }
    
    // MARK : Functions to call Udacity API for login.
    
    private func getRequestToken(){}

    private func loginWithToken(requestToken : String){}
    
    private func getSessionId(requestToken : String){}
    
    private func getUserId(sessionId : String){}
}