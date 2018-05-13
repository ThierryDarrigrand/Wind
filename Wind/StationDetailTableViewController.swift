//
//  StationDetailTableViewController.swift
//  Wind
//
//  Created by Thierry Darrigrand on 12/05/2018.
//  Copyright © 2018 Thierry Darrigrand. All rights reserved.
//

import UIKit

class StationDetailViewController: UITableViewController {
    var measurements: Station.Measurements?
    
    @IBOutlet weak var measurementDateLabel: UILabel!
    @IBOutlet weak var measurementWindHeadingLabel: UILabel!
    @IBOutlet weak var measurementWindAverageSpeedLabel: UILabel!
    @IBOutlet weak var measurementsWindMaxSpeedLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let measurements = measurements {
            measurementDateLabel.text = measurements.formattedDate
            measurementWindHeadingLabel.text = Station.Measurements.formattedAngle(measurements.windHeading)
            measurementWindAverageSpeedLabel.text =
            Station.Measurements.formattedSpeed(measurements.windSpeedAvg)
            measurementsWindMaxSpeedLabel.text = Station.Measurements.formattedSpeed(measurements.windSpeedMax)
        }
        
    }
}
