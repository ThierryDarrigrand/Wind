//
//  PiouPiou.swift
//  Wind
//
//  Created by Thierry Darrigrand on 12/05/2018.
//  Copyright © 2018 Thierry Darrigrand. All rights reserved.
//

import Foundation

struct PiouPiouData:Decodable, Equatable {
    let id: Int
    struct Meta: Decodable, Equatable {
        let name: String
        let description: String?
        let picture: String?
        let date: Date?
        struct Rating: Decodable, Equatable {
            let upvotes: Int
            let downvotes: Int
        }
        let rating: Rating? 
    }
    let meta: Meta
    struct Location:Decodable, Equatable {
        let latitude: Double?
        let longitude: Double?
        let date: Date?
        let success: Bool
    }
    let location: Location
    struct Measurements:Decodable, Equatable {
        let date: Date?
        let pressure: String? //nil
        /// degrees
        let windHeading: Double?
        /// km/h
        let windSpeedAvg: Double?
        /// km/h
        let windSpeedMax: Double?
        /// km/h
        let windSpeedMin: Double?
    }
    let measurements: Measurements
    struct Status:Decodable, Equatable {
        let date: Date?
        /// dB
        let snr: Double?
        let state: String?
    }
    let status: Status
    
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
    static var dateFormatter:DateFormatter {
        let piouPiouDateFormatter = DateFormatter()
        piouPiouDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.zzzZ" // 2018-05-24T09:23:32.000Z
        return piouPiouDateFormatter
    }
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
