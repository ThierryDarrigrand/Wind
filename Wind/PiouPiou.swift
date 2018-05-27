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

struct PiouPiouEndPoints {
    static var dateFormatter: DateFormatter = {
        let piouPiouDateFormatter = DateFormatter()
        piouPiouDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.zzzZ" // 2018-05-24T09:23:32.000Z
        return piouPiouDateFormatter
    }()
    static func singleStation(stationID: Int)-> Resource<PiouPiouSingleStation>{
        return Resource(url: URL(string:"http://api.pioupiou.fr/v1/live/\(stationID)")!, PiouPiouSingleStation.self, dateFormatter:dateFormatter)
    }
    static func allStations()-> Resource<PiouPiouStations>{
        return Resource(url: URL(string:"http://api.pioupiou.fr/v1/live/all")!, PiouPiouStations.self, dateFormatter:dateFormatter)
    }
    static func singleStationWithMeta(stationID: Int)-> Resource<PiouPiouSingleStation>{
        return Resource(url: URL(string:"http://api.pioupiou.fr/v1/live-with-meta/\(stationID)")!, PiouPiouSingleStation.self, dateFormatter:dateFormatter)
    }
    static func allStationsWithMeta()-> Resource<PiouPiouStations>{
        return Resource(url: URL(string:"http://api.pioupiou.fr/v1/live-with-meta/all")!, PiouPiouStations.self, dateFormatter:dateFormatter)
    }
    //    "http://api.pioupiou.fr/v1/archive/\(stationID)?start=\(start)&stop=\(stop)&format=\(format)",
    //    "http://api.pioupiou.fr/v1/archive/\(stationID)?start=\(start)&stop=\(stop)",
    
}

/*
 struct PiouPiouArchive: Decodable {
 let doc: String
 let license: String
 let attribution: String
 let legend: [String]
 let units: [String]
 let data: [[AnyObject]] // [[ String(Date) | Double | nil ]]
 }
 */
