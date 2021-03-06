//
//  MeasurementsViewController.swift
//  Wind
//
//  Created by Thierry Darrigrand on 02/06/2018.
//  Copyright © 2018 Thierry Darrigrand. All rights reserved.
//

import UIKit
import os

class MeasurementsViewController: UITableViewController {
    var station: Station! {
        didSet {
            station.measurements.sort{ lhs, rhs in
                lhs.date > rhs.date
            }

            updateUI()
        }
    }

    func updateUI() {
        self.title = "\(station.name)"
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if case .pioupiou(let id) = station.provider {
            Current.piouPiou.fetchArchive(id) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let archive):
                        os_log(#function)
                        self?.station.updateMeasurements(archive: archive)
                    case .failure(let error):
                        os_log(error as! StaticString)
                    }
                }
            }
            
        } 
        
    }



    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return station.measurements.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath)
        let measurement = station.measurements[indexPath.row]
        cell.textLabel?.text = measurement.formattedDate
        return cell
    }
    


    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? WindViewController,
            let indexPath = tableView.indexPathForSelectedRow {
            vc.measurement = station.measurements[indexPath.row]
        }
    }
    

}
