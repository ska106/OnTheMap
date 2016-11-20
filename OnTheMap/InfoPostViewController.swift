//
//  InfoPostViewController.swift
//  OnTheMap
//
//  Created by Sudeep Agrawal on 11/6/16.
//  Copyright © 2016 Agrawal. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class InfoPostViewController:UIViewController
{
    
    var parseClient : ParseClient!
    //Ref : https://developer.apple.com/reference/corelocation/clplacemark
    var placemark: CLPlacemark? = nil
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var mapURLText: UITextField!
    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Get the singleton instances of the API clients.
        parseClient = ParseClient.sharedInstance
        initializeScreen()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
    }
    
    @IBAction func cancelAction(sender: AnyObject)
    {
        if let presentingViewController = presentingViewController {
            presentingViewController.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func findAction(sender: AnyObject)
    {
        print(">>> findAction()")
        self.displayAlert("Button Pressed.")
    }
    
    @IBAction func submitAction(sender: AnyObject)
    {
        print (">>> submitAction(()")
    }
    
    func startActivity()
    {
        
    }
    
    func stopActivity()
    {
        
    }
    
    func displayAlert(message: String, completionHandler: ((UIAlertAction) -> Void)? = nil)
    {
        dispatch_async(dispatch_get_main_queue())
        {
            self.stopActivity()
            let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .Alert)
            let okButton = UIAlertAction(title: "OK", style: .Default, handler: completionHandler)
            alert.addAction(okButton)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func initializeScreen()
    {
        submitButton.hidden = true
        mapURLText.hidden = true
    }
    
}