//
//  Station.swift
//  Wind
//
//  Created by Thierry Darrigrand on 12/05/2018.
//  Copyright © 2018 Thierry Darrigrand. All rights reserved.
//

import Foundation
enum Provider:Equatable {
    case aemet(id: String)
    case pioupiou(id:Int)
}

extension Provider: CustomStringConvertible {
    var description: String {
        switch self {
        case .aemet(let id):
            return "AEMET.\(id)"
        case .pioupiou(let id):
            return "PiouPiou.\(id)"
        }
    }

}
struct Station:Equatable {
    var provider: Provider
    var name: String
    var latitude: Double
    var longitude: Double
    struct Measurement:Equatable {
        var date: Date
        var windHeading: Double?
        var windSpeedAvg: Double?
        var windSpeedMax: Double?
    }
    var measurements: [Measurement] = []
}
extension Station {
    init(piouPiouData: PiouPiouData) {
        self.provider = .pioupiou(id: piouPiouData.id)
        self.name = piouPiouData.meta.name
        self.latitude = piouPiouData.location.latitude ?? 0
        self.longitude = piouPiouData.location.longitude ?? 0
        if let measurement = Station.Measurement(piouPiouData: piouPiouData) {
            self.measurements = [measurement]
        }
    }
    mutating func updateMeasurements(archive: PiouPiouArchive) {
        measurements = archive.data.map(Station.Measurement.init(measurement:))
    }
    
    init(aemetDatos: AEMETDatos) {
        self.provider = .aemet(id: aemetDatos.idema)
        self.name = aemetDatos.ubi
        self.latitude = aemetDatos.lat
        self.longitude = aemetDatos.lon
        if let measurement = Station.Measurement(aemetData: aemetDatos) {
            self.measurements = [measurement]
        } 
    }
}

extension Station.Measurement {
    fileprivate init?(aemetData: AEMETDatos) {
        guard let date = aemetData.fint else { return nil }
        self.date = date
        self.windSpeedMax = aemetData.vmax.map{$0*3.6}
        self.windSpeedAvg = aemetData.vv.map{$0*3.6}
        self.windHeading = aemetData.dv
    }
    
    fileprivate init(measurement: PiouPiouArchive.Measurement) {
        self.date = measurement.date
        self.windSpeedMax = measurement.windSpeedMax
        self.windHeading = measurement.windHeading
        self.windSpeedAvg = measurement.windSpeedAvg
    }
    
    fileprivate init?(piouPiouData: PiouPiouData) {
        guard let date = piouPiouData.measurements.date else { return nil }
        self.date = date
        self.windHeading = piouPiouData.measurements.windHeading
        self.windSpeedAvg = piouPiouData.measurements.windSpeedAvg
        self.windSpeedMax = piouPiouData.measurements.windSpeedMax
    }
}

extension Array where Element == Station {
    init(aemetDatas: [AEMETDatos]) {
        let idemas: [String:Station] = aemetDatas.reduce(into: [:]) { idemas, aemetData in
            if var station = idemas[aemetData.idema] {
                if let measurement = Station.Measurement(aemetData: aemetData) {
                    station.measurements.append(measurement)
                    idemas[aemetData.idema] = station
                }
            } else {
                idemas[aemetData.idema] = Station(aemetDatos: aemetData)
            }
        }
        self = Array(idemas.values)
    }
    
    init(piouPiouDatas: [PiouPiouData]) {
        self = piouPiouDatas.map(Station.init)
    }
}


