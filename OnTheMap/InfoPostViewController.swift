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
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var studyLocationField: UITextField!
    
    var parseClient : ParseClient!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Get the singleton instances of the API clients.
        parseClient = ParseClient.sharedInstance
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
    }
    
    @IBAction func cancelButtonAction(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func bottomButtonAction(sender: AnyObject)
    {
        
    }
}