//
//  ViewController.swift
//  Wind
//
//  Created by Thierry Darrigrand on 12/05/2018.
//  Copyright © 2018 Thierry Darrigrand. All rights reserved.
//

import UIKit

//var Current = Environment.mock
var Current = Environment()
// TODO: tester erreurs
/*
 Current.gitHub.fetchRepos = { callback in
 callback(.failure(NSError.init(domain: "co.pointfree", code: 1, userInfo: [NSLocalizedDescriptionKey: "Ooops!"])))
 }

 */

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
        Current.piouPiouWebService.fetchPiouPiou{ [weak self] result in
            DispatchQueue.main.async {
                self?.stations += [Station](piouPiouDatas: result!.data)
            }
        }
 
        Current.aemetWebService.fetchAemet{ [weak self] result in
            if let result = result {
                let url = URL(string:result.datos)!
                Current.aemetWebService.fetchAemetDatos(url) { aemetDatas in
                    DispatchQueue.main.async {
                        self?.stations += [Station](aemetDatas: aemetDatas!)
                    }
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

