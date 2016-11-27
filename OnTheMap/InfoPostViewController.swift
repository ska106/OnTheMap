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

class InfoPostViewController:UIViewController, UITextFieldDelegate
{
    
    var parseClient : ParseClient!
    var udClient : UdacityClient!
    
    //Ref : https://developer.apple.com/reference/corelocation/clplacemark
    var placemark: CLPlacemark? = nil
    var studentObjectId:String? = nil
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var mapURLText: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
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
        udClient = UdacityClient.sharedInstance
        
        initializeScreen()
        
        locationText.delegate = self
        mapURLText.delegate = self
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
    }
    
    @IBAction func cancelAction(sender: AnyObject)
    {
        //print(">>> cancelAction()")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
    
    @IBAction func findAction(sender: AnyObject)
    {
        //print(">>> findAction()")
        //print(locationText.text)
        if (locationText.text == nil || locationText.text == "")
        {
            displayAlert("Please enter a location.")
            return
        }
        else
        {
            startActivity()
            let LOC_NOT_FOUND = "Could not find location entered. Please retry."
            // put in a delay.
            let delayInSeconds = 1.25
            let delay = delayInSeconds * Double(NSEC_PER_SEC)
            let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(popTime, dispatch_get_main_queue(),
            {
                //Ref : http://stackoverflow.com/questions/24345296/swift-clgeocoder-reversegeocodelocation-completionhandler-closure
                let geocoder = CLGeocoder()
                do
                {
                    geocoder.geocodeAddressString(self.locationText.text!, completionHandler: { (results, error) in
                        if let error = error
                        {
                            print (error.description)
                            self.displayAlert(LOC_NOT_FOUND)
                        }
                        else if (results!.isEmpty)
                        {
                            self.displayAlert(LOC_NOT_FOUND)
                        }
                        else
                        {
                            self.placemark = results![0]
                            self.initializeScreen(2)
                            self.startActivity(false)
                            self.mapView.showAnnotations([MKPlacemark(placemark: self.placemark!)], animated: true)
                        }
                    })
                }
            })
        }
    }
    
    @IBAction func submitAction(sender: AnyObject)
    {
        print (">>> submitAction(()")
        startActivity()
        if (mapURLText.text == nil || mapURLText.text == "")
        {
            displayAlert("Please enter a location.")
            startActivity(false)
            return
        }
        else
        {
            let id = udClient.uniqueId == nil ? "":udClient.uniqueId
            
            let updatedStud:[String:AnyObject] = ["firstName" : udClient.userFirstName,
                                                  "lastName" : udClient.userLastName,
                                                  "uniqueKey" : id!,
                                                  "mapString" : mapURLText!.text!,
                                                  "mediaURL" : locationText!.text!,
                                                  "longitude" : (placemark!.location?.coordinate.longitude)!,
                                                  "latitude" : (placemark!.location?.coordinate.latitude)!]
 
            if !((id?.isEmpty)!)
            {
                parseClient.updateStudentLocation(udClient.userObjectId!, studentData: updatedStud, completionHandler: { (success, errorMessage) in
                    if (success)
                    {
                        print ("Data has been updated.")
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                    else
                    {
                        self.displayAlert("Error occurred : \(errorMessage)" )
                    }
                })
            }
            else
            {
                parseClient.postStudentLocation(updatedStud, completionHandler: { (success, errorMessage) in
                    if (success)
                    {
                        //print ("Data has been updated.")
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                    else
                    {
                        self.displayAlert("Error occurred : \(errorMessage)" )
                    }
                })
            }
            startActivity(false)
            
        }
    }
    
    func startActivity(started:Bool = true)
    {
        activityIndicator.hidden = !started
        findButton.enabled = !started
        cancelButton.enabled = !started
        submitButton.enabled = !started
        if (started)
        {
            activityIndicator.startAnimating()
        }
        else
        {
            activityIndicator.stopAnimating()
        }
    }
    
    func displayAlert(message: String, completionHandler: ((UIAlertAction) -> Void)? = nil)
    {
        dispatch_async(dispatch_get_main_queue())
        {
            self.startActivity(false)
            let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .Alert)
            let okButton = UIAlertAction(title: "OK", style: .Default, handler: completionHandler)
            alert.addAction(okButton)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    // stageNumber = 1 : the UI components needed for the first time view (Defaulted)
    // stageNumber = 2 : the UI components needed for the second time view
    func initializeScreen(stageNumber :Int = 1)
    {
        activityIndicator.hidden = true
        switch (stageNumber)
        {
            case 1 :
                submitButton.hidden = true
                findButton.hidden = false
                locationText.hidden = false
                middleView.hidden = false
                mapURLText.hidden = true
                topLabel.text = "Where are you studying today ?"
            case 2 :
                submitButton.hidden = false
                findButton.hidden = true
                locationText.hidden = true
                middleView.hidden = true
                mapURLText.hidden = false
                topLabel.text = "Enter a URL for your location."
            default: break
        }
    }
}