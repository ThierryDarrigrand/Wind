//
//  Station.swift
//  Wind
//
//  Created by Thierry Darrigrand on 12/05/2018.
//  Copyright © 2018 Thierry Darrigrand. All rights reserved.
//


 struct Station {
    let id: String
    let name: String
    let latitude: Double
    let longitude: Double
    struct Measurement:Decodable {
        let date: Date
        let windHeading: Double?
        let windSpeedAvg: Double?
        let windSpeedMax: Double?
    }
    var measurements: [Measurement]
}
extension Station {
    init(piouPiouData: PiouPiouData) {
        self.id = "PiouPiou.\(piouPiouData.id)"
        self.name = piouPiouData.meta.name
        self.latitude = piouPiouData.location.latitude ?? 0
        self.longitude = piouPiouData.location.longitude ?? 0
        if let measurement = Station.Measurement(piouPiouData: piouPiouData) {
            self.measurements = [measurement]
        } else {
            self.measurements = []
        }
    }
    
    init(aemetDatos: AemetDatos) {
        self.id = "Aemet.\(aemetDatos.idema)"
        self.name = aemetDatos.ubi
        self.latitude = aemetDatos.lat
        self.longitude = aemetDatos.lon
        self.measurements = []
    }
}

extension Station.Measurement {
    init?(aemetData: AemetDatos) {
        guard let date = aemetData.fint else { return nil }
        self.date = date
        self.windSpeedMax = aemetData.vmax.map{$0*3.6}
        self.windSpeedAvg = aemetData.vv.map{$0*3.6}
        self.windHeading = aemetData.dv
    }
    init?(piouPiouData: PiouPiouData) {
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
            var  station = idemas[aemetData.idema, default: Station(aemetDatos: aemetData)]
            if let measurement = Station.Measurement(aemetData: aemetData) {
                station.measurements.append(measurement)
            }
            idemas[aemetData.idema] = station
        }
        self = Array(idemas.values)
    }
    
    init(piouPiouDatas: [PiouPiouData]) {
        self = piouPiouDatas.map(Station.init)
    }
}


import Foundation

extension Station {
    var title: String {
        return "\(name) - \(id)"
    }
}


extension Station.Measurement {
    static var newFormatter: DateFormatter = {
        let newFormatter = DateFormatter()
        newFormatter.dateStyle = .medium
        newFormatter.timeStyle = .medium
        return newFormatter
    }()
    
    var formattedDate: String {
        return Station.Measurement.newFormatter.string(from: date)
    }
    
    static func formattedSpeed(_ speed: Double)->String {
        return "\(speed) km/h"
    }
    
    static func formattedAngle(_ speed: Double)->String {
        return "\(speed) º"
    }

}
