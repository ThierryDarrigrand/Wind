//
//  MeasurementsViewController.swift
//  Wind
//
//  Created by Thierry Darrigrand on 02/06/2018.
//  Copyright © 2018 Thierry Darrigrand. All rights reserved.
//

import UIKit

class MeasurementsViewController: UITableViewController {
    var station: Station! {
        didSet {
            station.measurements = station.measurements.sorted { (lhs, rhs) -> Bool in
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
        let ids = station.id.split(separator:".")

        if ids[0] == "PiouPiou" {
            if station == nil { station = Station(id:"PiouPiou.0", name:"X", latitude: 0, longitude:0, measurements: [])}
            Current.piouPiou.fetchArchive(PiouPiouEndPoints.archive(stationID: Int(ids[1])!, startDate: .lastDay, stopDate: .now)) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let archive):
                        if var stationFromArchive = Station(piouPiouArchive: archive) {
                            stationFromArchive.name = (self?.station.name)!
                            self?.station = stationFromArchive
                            
                        } else {
                            self?.station.measurements = []
                        }
                    case .failure(let error):
                        print("\(error)")
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
