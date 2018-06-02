//
//  StationDetailTableViewController.swift
//  Wind
//
//  Created by Thierry Darrigrand on 12/05/2018.
//  Copyright © 2018 Thierry Darrigrand. All rights reserved.
//

import UIKit

class WindViewController: UITableViewController {
    var measurement: Station.Measurement!
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var speedMaxLabel: UILabel!
    @IBOutlet weak var speedAvgLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = measurement.formattedDate
        
        headingLabel.text = measurement.windHeading.map{Station.Measurement.formattedAngle($0)} ?? ""
        speedAvgLabel.text = measurement.windSpeedAvg.map{Station.Measurement.formattedSpeed($0)} ?? ""
        speedMaxLabel.text = measurement.windSpeedMax.map{Station.Measurement.formattedSpeed($0)} ?? ""
    }
}
