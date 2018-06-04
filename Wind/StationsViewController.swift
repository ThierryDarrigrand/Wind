//
//  ViewController.swift
//  Wind
//
//  Created by Thierry Darrigrand on 12/05/2018.
//  Copyright © 2018 Thierry Darrigrand. All rights reserved.
//

import UIKit

class StationsViewController: UITableViewController {
    var stations: [Station] = [] {
        didSet {
            stations.sort{ lhs, rhs in lhs.name < rhs.name }
            updateUI()
        }
    }
    
    func updateUI() {
        self.title = "Stations (\(stations.count))"
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppEnvironment.current.piouPiou.fetchStations() { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let piouPiouStations):
                    self?.stations += [Station](piouPiouDatas: piouPiouStations.data)
                case .failure(let error):
                    print("\(error)")
                }
            }
        }
        
        AppEnvironment.current.aemet.fetch() { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let responseSuccess):
                    let url = responseSuccess.datos
                    AppEnvironment.current.aemet.fetchDatas(url) { [weak self] result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let aemetDatas):
                                self?.stations += [Station](aemetDatas: aemetDatas)
                            case .failure(let error):
                                print("\(error)")
                            }
                        }
                    }
                case .failure(let error):
                    print("\(error)")
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StationCell", for: indexPath)
        let station = stations[indexPath.row]
        cell.textLabel?.text = station.name
        cell.detailTextLabel?.text = "\(station.provider)"
        return cell
    }
    
     // MARK: - Navigation     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MeasurementsViewController,
            let indexPath = tableView.indexPathForSelectedRow {
            print(#function)
            vc.station = stations[indexPath.row]
        }
    }
    
    
}

