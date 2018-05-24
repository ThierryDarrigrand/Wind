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
        Webservice.load(PiouPiouEndPoints.allStationsWithMeta()) { [weak self] result in
            DispatchQueue.main.async {
                self?.stations += [Station](piouPiouDatas: result!.data)
            }
        }
 
        /*
        Webservice.load(AEMETEndPoints.observacionConvencionalTodas()) {  [weak self] result in
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
        let fileURL = Bundle.main.url(forResource: "Aemet", withExtension: "txt")
        let data = try! Data(contentsOf: fileURL!)
        
        var aemetDatas:[AemetDatos] = []
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let aemetDateFormatter = DateFormatter()
        aemetDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        aemetDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        decoder.dateDecodingStrategy = .formatted(aemetDateFormatter)

        do {
            aemetDatas = try decoder.decode([AemetDatos].self, from: data)
        }
        catch {
            // erreur de decodage du json
            print(error)
        }
        DispatchQueue.main.async {
            self.stations += [Station](aemetDatas: aemetDatas)
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

