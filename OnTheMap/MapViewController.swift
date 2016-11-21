//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Sudeep Agrawal on 11/6/16.
//  Copyright © 2016 Agrawal. All rights reserved.
//

import Foundation
import MapKit


/**
 * This view controller demonstrates the objects involved in displaying pins on a map.
 *
 * The map is a MKMapView.
 * The pins are represented by MKPointAnnotation instances.
 *
 * The view controller conforms to the MKMapViewDelegate so that it can receive a method
 * invocation when a pin annotation is tapped. It accomplishes this using two delegate
 * methods: one to put a small "info" button on the right side of each pin, and one to
 * respond when the "info" button is tapped.
 */
class MapViewController : UIViewController, MKMapViewDelegate
{
    
    @IBOutlet weak var mapview: MKMapView!
    
    var parseClient : ParseClient!
    var udClient : UdacityClient!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Get the singleton instances of the API clients.
        parseClient = ParseClient.sharedInstance
        udClient = UdacityClient.sharedInstance
        self.loadData()
        
    }
   
    @IBAction func performLogout(sender: AnyObject)
    {
        print(">>> MapViewController.performLogout")
        udClient.logout { (success, errorMessage) in
            if success == true
            {
                let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("LoginVC") as! LoginViewController
                self.presentViewController(loginVC,animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func performRefresh(sender: AnyObject)
    {
        print(">>> MapViewController.performRefresh")
        self.loadData()
    }
    
    func loadData()
    {
        parseClient.getStudentLocations() { success, errorMessage in
            
            // We will create an MKPointAnnotation for each dictionary in "locations". The
            // point annotations will be stored in this array, and then provided to the map view.
            var annotations = [MKPointAnnotation]()
            
            if success
            {
                //On Success
                
                // The "studentLocations" (from ParseClient) array is loaded with the needed data to be displayed on the map. We are using the dictionaries
                // to create map annotations.
                for location in self.parseClient.studentLocations
                {
                    //Assign the co-ordinates.
                    let lat = CLLocationDegrees(location.latitude!)
                    let long = CLLocationDegrees(location.longitude!)
                    
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    let annotation = MKPointAnnotation()
                    annotation.title = "\(location.firstName!) \(location.lastName!)"
                    annotation.subtitle = location.mediaURL
                    annotation.coordinate = coordinate
                    annotations.append(annotation)
                }
            }
            else
            {
                //Failure
                print("Error has occurred when invoking the ParseClient to fetch StudentLocations.")
                //Ref: http://stackoverflow.com/questions/24022479/how-would-i-create-a-uialertview-in-swift
                let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
                let dismissAction = UIAlertAction(title: "OK", style: .Default,handler: nil)
                alert.addAction(dismissAction)
                dispatch_async(dispatch_get_main_queue())
                {
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
            
            dispatch_async(dispatch_get_main_queue())
            {
                self.mapview.addAnnotations(annotations)
                self.mapview.alpha = 1.0
            }
        }
    }
    
    
    // MARK: - MKMapViewDelegate
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?
    {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil
        {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else
        {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    @IBAction func openInfoPostVC(sender: AnyObject)
    {
        let infoPostViewController = self.storyboard!.instantiateViewControllerWithIdentifier("InfoPostVC") as! InfoPostViewController
        self.presentViewController(infoPostViewController, animated: true, completion: nil)
    }
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
        if control == view.rightCalloutAccessoryView
        {
            let app = UIApplication.sharedApplication()
            let mediaURL = NSURL(string:((view.annotation?.subtitle)!)!)
            if app.canOpenURL(mediaURL!)
            {
                app.openURL(mediaURL!)
            }
        }
    }
}