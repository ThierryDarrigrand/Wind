//
//  StationDetailTableViewController.swift
//  Wind
//
//  Created by Thierry Darrigrand on 12/05/2018.
//  Copyright © 2018 Thierry Darrigrand. All rights reserved.
//

import UIKit

class StationDetailViewController: UITableViewController {
    var measurements: Station.Measurement?
    
    @IBOutlet weak var measurementDateLabel: UILabel!
    @IBOutlet weak var measurementWindHeadingLabel: UILabel!
    @IBOutlet weak var measurementWindAverageSpeedLabel: UILabel!
    @IBOutlet weak var measurementsWindMaxSpeedLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let measurements = measurements {
            measurementDateLabel.text =
                measurements.formattedDate
            measurementWindHeadingLabel.text =
                measurements.windHeading.map{Station.Measurement.formattedAngle($0)} ?? ""
            measurementWindAverageSpeedLabel.text = measurements.windSpeedAvg.map{Station.Measurement.formattedSpeed($0)} ?? ""
            measurementsWindMaxSpeedLabel.text =
                measurements.windSpeedMax.map{Station.Measurement.formattedSpeed($0)} ?? ""
        }
        
    }
}
