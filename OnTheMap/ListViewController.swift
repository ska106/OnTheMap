//  ListViewController.swift
//  OnTheMap
//
//  Created by Sudeep Agrawal on 11/6/16.
//  Copyright © 2016 Agrawal. All rights reserved.
//

import Foundation
import UIKit

class ListViewController:UIViewController, UITableViewDataSource, UITableViewDelegate
{
    var parseClient:ParseClient!
    var udClient:UdacityClient!
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var postButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Get the singleton instances of the API clients.
        parseClient = ParseClient.sharedInstance
        udClient = UdacityClient.sharedInstance
        tableView.delegate = self
    }
    
    override func viewWillAppear(animated:Bool)
    {
        super.viewWillAppear(animated)
        loadData()
    }
        
    @IBAction func performLogout(sender: AnyObject)
    {
        //print(">>>ListViewController.performLogout")
        enableButtons(false)
        udClient.logout { (success, errorMessage) in
            if success == true
            {
                let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("LoginVC") as! LoginViewController
                self.presentViewController(loginVC,animated: true, completion: nil)
            }
            else
            {
                self.enableButtons()
            }
        }
    }
   
    @IBAction func performRefresh(sender: AnyObject)
    {
        //print(">>>ListViewController.performRefresh")
        loadData()
    }
    
    func enableButtons(enable:Bool = true)
    {
        logoutButton.enabled = enable
        postButton.enabled = enable
        refreshButton.enabled = enable
        tabBarController?.tabBar.items![0].enabled = enable
        tabBarController?.tabBar.items![1].enabled = enable
    }
    
    func loadData()
    {
        parseClient.getStudentLocations { (success, errorMessage) in
            if success
            {
                dispatch_async(dispatch_get_main_queue())
                {
                    self.tableView.reloadData()
                }
            }
            else
            {
                //Display error message
                let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
                let dismissAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alert.addAction(dismissAction)
                dispatch_async(dispatch_get_main_queue())
                {
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
            
        }
    }
    
    @IBAction func openInfoPostVC(sender: AnyObject)
    {
        let infoPostViewController = storyboard!.instantiateViewControllerWithIdentifier("InfoPostVC") as! InfoPostViewController
        presentViewController(infoPostViewController, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let student = parseClient.studentLocations[indexPath.row]
        
        let app = UIApplication.sharedApplication()
        if let url = NSURL(string: student.mediaURL!)
        {
            app.openURL( url )
        }
        else
        {
            //print("ERROR: Invalid url")
        }
    }
    
    //MARK : Function that determines the number for Rows in the table. This will be dependent on the record set fetched
    //       by the parseClient --> StudentLocations[]
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return parseClient.studentLocations.count
    }
    
    // MARK : Function that defines the content for each cell in the table.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("studentLocationCell", forIndexPath: indexPath) as! StudentLocationTableViewCell
        let location = parseClient.studentLocations[indexPath.row]
        cell.configureTableCell(location)
        return cell
    }
}