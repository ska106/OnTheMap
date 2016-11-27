//
//  StudentLocationTableViewCell.swift
//  OnTheMap
//
//  Created by Sudeep Agrawal on 11/26/16.
//  Copyright © 2016 Agrawal. All rights reserved.
//

import Foundation
import UIKit

class StudentLocationTableViewCell : UITableViewCell
{
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var pinView: UIImageView!
    
    func configureTableCell (student:StudentInformation)
    {
        self.pinView.image = UIImage(named: "pin")
        self.fullName.text = student.getFullName()
    }
}