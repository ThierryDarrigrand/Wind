//
//  ViewController.swift
//  Wind
//
//  Created by Thierry Darrigrand on 12/05/2018.
//  Copyright © 2018 Thierry Darrigrand. All rights reserved.
//

import UIKit

var Current = Environment.mock
//var Current = Environment() // Aemet reste mock en absence de certificat

class StationsListViewController: UITableViewController {
    var stations: [Station] = [] {
        didSet {
            stations.sort { lhs, rhs in lhs.title < rhs.title }
            updateUI()
        }
    }
    
    func updateUI() {
        self.title = "Stations (\(stations.count))"
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        Current.piouPiou.fetchStations(PiouPiouEndPoints.allStationsWithMeta()) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let piouPiouStations):
                    self?.stations += [Station](piouPiouDatas: piouPiouStations.data)
                case .failure(let error):
                    print("\(error)")
                }
            }
        }
 
        Current.aemet.fetch(AEMETEndPoints.observacionConvencionalTodas()){ [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let responseSuccess):
                    let url = URL(string:responseSuccess.datos)!
                    Current.aemet.fetchDatas(AEMETEndPoints.datos(url: url)) { [weak self] result in
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
        cell.detailTextLabel?.text = station.id
        return cell
    }
    
     // MARK: - Navigation     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? StationDetailViewController,
            let indexPath = tableView.indexPathForSelectedRow {
            vc.measurements = stations[indexPath.row].measurements.last
            vc.title = stations[indexPath.row].name
        }
     }


}

