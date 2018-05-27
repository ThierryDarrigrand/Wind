//
//  Station.swift
//  Wind
//
//  Created by Thierry Darrigrand on 12/05/2018.
//  Copyright © 2018 Thierry Darrigrand. All rights reserved.
//

import Foundation

struct Station:Equatable, Comparable {
    static func < (lhs: Station, rhs: Station) -> Bool {
        return lhs.id < rhs.id
    }
    
    var id: String
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
        self.id = "PiouPiou.\(piouPiouData.id)"
        self.name = piouPiouData.meta.name
        self.latitude = piouPiouData.location.latitude ?? 0
        self.longitude = piouPiouData.location.longitude ?? 0
        if let measurement = Station.Measurement(piouPiouData: piouPiouData) {
            self.measurements = [measurement]
        }
    }
    
    init(aemetDatos: AemetDatos) {
        self.id = "Aemet.\(aemetDatos.idema)"
        self.name = aemetDatos.ubi
        self.latitude = aemetDatos.lat
        self.longitude = aemetDatos.lon
        if let measurement = Station.Measurement(aemetData: aemetDatos) {
            self.measurements = [measurement]
        } 
    }
}

extension Station.Measurement {
    fileprivate init?(aemetData: AemetDatos) {
        guard let date = aemetData.fint else { return nil }
        self.date = date
        self.windSpeedMax = aemetData.vmax.map{$0*3.6}
        self.windSpeedAvg = aemetData.vv.map{$0*3.6}
        self.windHeading = aemetData.dv
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
    init(aemetDatas: [AemetDatos]) {
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


