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
    struct Measurements:Decodable {
        let date: String
        let windHeading: Double
        let windSpeedAvg: Double
        let windSpeedMax: Double
    }
    let measurements: Measurements
    
    
    init(piouPiouData: PiouPiouData) {
        self.id = "PiouPiou.\(piouPiouData.id)"
        self.name = piouPiouData.meta.name
        self.latitude = piouPiouData.location.latitude ?? 0
        self.longitude = piouPiouData.location.longitude ?? 0
        self.measurements = Measurements(
            date: piouPiouData.measurements.date!,
            windHeading: piouPiouData.measurements.windHeading ?? 0,
            windSpeedAvg: piouPiouData.measurements.windSpeedAvg ?? 0,
            windSpeedMax: piouPiouData.measurements.windSpeedMax ?? 0)
    }
    
    init(aemeDatos: AEMEDatos) {
        self.id = "Aemet.\(aemeDatos.idema)"
        self.name = aemeDatos.ubi
        self.latitude = aemeDatos.lat
        self.longitude = aemeDatos.lon
        self.measurements = Measurements(
            date: aemeDatos.fint!,
            windHeading: aemeDatos.dv ?? 0,
            windSpeedAvg: aemeDatos.vv ?? 0 * 3.6,
            windSpeedMax: aemeDatos.vmax ?? 0 * 3.6)
    }
}

import Foundation

extension Station {
    var title: String {
        return "\(name) - \(id)"
    }
}


extension Station.Measurements {
    static var newFormatter: DateFormatter = {
        print(#function, "newFormatter")
        let newFormatter = DateFormatter()
        newFormatter.dateStyle = .medium
        newFormatter.timeStyle = .medium
        return newFormatter
    }()

    static var formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withYear, .withMonth, .withDay, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        return formatter
    }()
    
    var formattedDate: String {
        let newDate = Station.Measurements.formatter.date(from: date)!
        return Station.Measurements.newFormatter.string(from: newDate)
    }
    
    static func formattedSpeed(_ speed: Double)->String {
        return "\(speed) km/h"
    }
    
    static func formattedAngle(_ speed: Double)->String {
        return "\(speed) º"
    }

}
