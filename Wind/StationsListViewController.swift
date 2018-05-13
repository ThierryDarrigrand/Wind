//
//  ViewController.swift
//  Wind
//
//  Created by Thierry Darrigrand on 12/05/2018.
//  Copyright © 2018 Thierry Darrigrand. All rights reserved.
//

import UIKit

class StationsListViewController: UITableViewController {
    var stations: [Station] = [] {
        didSet {
            stations.sort { (lhs, rhs) -> Bool in
                lhs.title < rhs.title
            }
            updateUI()
        }
    }
    
    func updateUI() {
        self.title = "Stations (\(stations.count))"
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Webservice.load(PiouPiouEndPoints.allStations()) { result in
            let stations = result!.data.map(Station.init)
            DispatchQueue.main.async {
                self.stations += stations
            }
        }
 
        /*
        Webservice.load(AEMETEndPoints.observacionConvencionalTodas()) { result in
            if let result = result {
                let url = URL(string:result.datos)!
                Webservice.load(Resource(url: url, [AEMEDatos].self)) { aemeDatas in
                    let stations = aemeDatas!.map(Station.init)
                    DispatchQueue.main.async {
                        self.stations += stations
                    }
                }
            }
        }
 */

        // tant que le certificat de Aeme n'est pas accessible:
        let fileURL = Bundle.main.url(forResource: "json", withExtension: "txt")
        let data = try! Data(contentsOf: fileURL!)
        
        var aemeDatas:[AEMEDatos] = []
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            aemeDatas = try decoder.decode([AEMEDatos].self, from: data)
        }
        catch {
            // erreur de decodage du json
            print(error)
        }
        let stations = aemeDatas.prefix(upTo: 500).map(Station.init)
        DispatchQueue.main.async {
            self.stations += stations
        }

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StationCell", for: indexPath)
        let station = stations[indexPath.row]
        cell.textLabel?.text = station.title
        return cell
    }
    
     // MARK: - Navigation     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? StationDetailViewController,
            let indexPath = tableView.indexPathForSelectedRow {
            vc.measurements = stations[indexPath.row].measurements
        }
     }


}

