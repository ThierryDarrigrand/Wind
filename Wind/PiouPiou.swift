//
//  PiouPiou.swift
//  Wind
//
//  Created by Thierry Darrigrand on 12/05/2018.
//  Copyright © 2018 Thierry Darrigrand. All rights reserved.
//

import Foundation

struct PiouPiouData:Decodable, Equatable {
    var id: Int
    struct Meta: Decodable, Equatable {
        var name: String
        var description: String?
        var picture: String?
        var date: Date?
        struct Rating: Decodable, Equatable {
            var upvotes: Int
            var downvotes: Int
        }
        var rating: Rating?
    }
    var meta: Meta
    struct Location:Decodable, Equatable {
        var latitude: Double?
        var longitude: Double?
        var date: Date?
        var success: Bool
    }
    var location: Location
    struct Measurements:Decodable, Equatable {
        var date: Date?
        var pressure: String? //nil
        /// degrees
        var windHeading: Double?
        /// km/h
        var windSpeedAvg: Double?
        /// km/h
        var windSpeedMax: Double?
        /// km/h
        var windSpeedMin: Double?
    }
    var measurements: Measurements
    struct Status:Decodable, Equatable {
        var date: Date?
        /// dB
        var snr: Double?
        var state: String?
    }
    var status: Status
    
}

struct PiouPiouStations:Decodable {
    let doc: String
    let license: String
    let attribution: String
    let data: [PiouPiouData]
}

struct PiouPiouSingleStation:Decodable, Equatable {
    let doc: String
    let license: String
    let attribution: String
    let data: PiouPiouData
}

struct PiouPiouArchive: Equatable {
    let doc: String?
    let license: String
    let attribution: String
    var legend: [String]
    var units: [String]
    struct Measurement: Equatable {
        var id: Int
        var date: Date
        var latitude:  Double?
        var longitude: Double?
        var windSpeedMin: Double?
        var windSpeedAvg: Double?
        var windSpeedMax: Double?
        var windHeading: Double?
        var pressure: Double?
    }
    var data: [Measurement]
}

extension DateFormatter {
    func stringZ(from date:Date)->String {
        return self.string(from: date).dropLast(5).appending("Z")
    }
}
struct PiouPiouEndPoints {
    static var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // 2018-05-24T09:23:32.000Z
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        return dateFormatter
    }()
    
    static func live(withMeta: Bool, stationId: Int)-> Resource<PiouPiouSingleStation>{
        return Resource(url: URL(string:"http://api.pioupiou.fr/v1/\(withMeta ? "live-with-meta" : "live")/\(stationId)")!, PiouPiouSingleStation.self, dateFormatter:dateFormatter)
    }
    
    static func live(withMeta: Bool)-> Resource<PiouPiouStations>{
        return Resource(url: URL(string:"http://api.pioupiou.fr/v1/\(withMeta ? "live-with-meta" : "live")/all")!, PiouPiouStations.self, dateFormatter:dateFormatter)
    }

    static func archive(stationID: Int, startDate:StartDate, stopDate: StopDate)-> Resource<PiouPiouArchive> {
        return Resource(url: url(stationID, startDate, stopDate, dateFormatter), parse:parseCSV(stationID, dateFormatter))
    }
}

enum StartDate {
    case date(Date)
    case lastHour
    case lastDay
    case lastWeek
    case lastMonth
}
enum StopDate {
    case date(Date)
    case now
}

private func url(_ stationID: Int, _ startDate: StartDate, _ stopDate: StopDate, _ dateFormatter: DateFormatter ) -> URL {
    let start:String
    switch startDate {
    case let .date(startDate): start = dateFormatter.stringZ(from: startDate)
    case .lastHour: start = "last-hour"
    case .lastDay: start = "last-day"
    case .lastMonth: start = "last-month"
    case .lastWeek: start = "last-week"
    }
    
    let stop:String
    switch stopDate {
    case .date(let stopDate): stop = dateFormatter.stringZ(from: stopDate)
    case .now: stop = "now"
    }
    
    return URL(string: "http://api.pioupiou.fr/v1/archive/\(stationID)?start=\(start)&stop=\(stop)&format=csv")!
}

private func parseCSV(_ stationID: Int, _ dateFormatter: DateFormatter) -> (Data) -> PiouPiouArchive? {
    return { data in
        guard let csv = String(data: data, encoding: .utf8) else { return nil }
        let lines = csv.split(separator: "\n")
        guard lines.count >= 4 else { return nil }
        
        var license = ""
        var attribution = ""
        var legend = [String]()
        var units = [String]()
        var measurements = [PiouPiouArchive.Measurement]()
        for (idx, line) in lines.enumerated() {
            let fields = line.split(separator: ",")
            switch idx {
            case 0:
                guard fields[0].removeQuotes() == "License", fields.count == 2 else { return nil }
                license = String((fields[1].removeQuotes()))
            case 1:
                guard fields[0].removeQuotes() == "Attribution", fields.count == 2 else { return nil }
                attribution = String(fields[1].removeQuotes())
            case 2:
                guard fields.count == 8 else { return nil }
                legend = fields.map{String($0.removeQuotes())}
            case 3:
                guard fields.count == 8 else { return nil }
                units = fields.map{String($0.removeQuotes())}
            case let x where x >= 4:
                guard fields.count == 8, let date = dateFormatter.date(from: String(fields[0].removeQuotes())) else { return nil }
                let measurement = PiouPiouArchive.Measurement(
                    id: stationID,
                    date: date,
                    latitude: Double(fields[1]),
                    longitude: Double(fields[2]),
                    windSpeedMin: Double(fields[3]),
                    windSpeedAvg: Double(fields[4]),
                    windSpeedMax: Double(fields[5]),
                    windHeading: Double(fields[6]),
                    pressure: Double(fields[7]))
                measurements += [measurement]
            default: fatalError()
            }
        }
        return PiouPiouArchive(doc: nil, license: license, attribution: attribution, legend: legend, units: units, data: measurements)
    }
}

extension StringProtocol {
    func removeQuotes() -> Self.SubSequence {
        return self.dropFirst().dropLast()
    }
}
