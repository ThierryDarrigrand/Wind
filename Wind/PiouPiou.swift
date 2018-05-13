//
//  PiouPiou.swift
//  Wind
//
//  Created by Thierry Darrigrand on 12/05/2018.
//  Copyright © 2018 Thierry Darrigrand. All rights reserved.
//

import Foundation

struct PiouPiouData:Decodable {
    let id: Int
    struct Meta: Decodable {
        let name: String
        let description: String?
        let picture: String?
        let date: String?
        struct Rating: Decodable {
            let upvotes: Int
            let downvotes: Int
        }
        let rating: Rating? 
    }
    let meta: Meta
    struct Location:Decodable {
        let latitude: Double?
        let longitude: Double?
        let date: String?
        let success: Bool
    }
    let location: Location
    struct Measurements:Decodable {
        let date: String?
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
    struct Status:Decodable {
        let date: String?
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

struct PiouPiouSingleStation:Decodable {
    let doc: String
    let license: String
    let attribution: String
    let data: PiouPiouData
}

struct PiouPiouEndPoints {
    static func singleStation(stationID: Int)-> Resource<PiouPiouSingleStation>{
        return Resource(url: URL(string:"http://api.pioupiou.fr/v1/live/\(stationID)")!, PiouPiouSingleStation.self)
    }
    static func allStations()-> Resource<PiouPiouStations>{
        return Resource(url: URL(string:"http://api.pioupiou.fr/v1/live/all")!, PiouPiouStations.self)
    }
    static func singleStationWithMeta(stationID: Int)-> Resource<PiouPiouSingleStation>{
        return Resource(url: URL(string:"http://api.pioupiou.fr/v1/live-with-meta/\(stationID)")!, PiouPiouSingleStation.self)
    }
    static func allStationsWithMeta()-> Resource<PiouPiouStations>{
        return Resource(url: URL(string:"http://api.pioupiou.fr/v1/live-with-meta/all")!, PiouPiouStations.self)
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
