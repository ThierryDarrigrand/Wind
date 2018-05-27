//
//  StationTests.swift
//  WindTests
//
//  Created by Thierry Darrigrand on 27/05/2018.
//  Copyright © 2018 Thierry Darrigrand. All rights reserved.
//

import XCTest
@testable import Wind

class StationPiouPiouTests: XCTestCase {
    
//    lazy var dateFormatter: DateFormatter = {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.zzzZ" // 2018-05-24T09:23:32.000Z
//        return dateFormatter
//    }()
    
    var piouPiouData = PiouPiouData(
        id: 19,
        meta: PiouPiouData.Meta(
            name: "Porto Rico",
            description: nil,
            picture: nil,
            date: nil,
            rating: nil),
        location: PiouPiouData.Location(
            latitude: 45,
            longitude: 20,
            date: nil,
            success: false),
        measurements: PiouPiouData.Measurements(
            date: Date(timeIntervalSinceReferenceDate: 557152051),
            pressure: nil,
            windHeading: 315,
            windSpeedAvg: 4.6,
            windSpeedMax: 5.5,
            windSpeedMin: 2.3),
        status: PiouPiouData.Status(
            date: Date(timeIntervalSinceReferenceDate: 557152051),
            snr: 21.96,
            state: "on")
    )
    func testConversionFromPiouPiou() {
        let expectedStation = Station(id: "PiouPiou.19", name: "Porto Rico", latitude: 45, longitude: 20, measurements: [Station.Measurement(date: Date(timeIntervalSinceReferenceDate: 557152051), windHeading: 315, windSpeedAvg: 4.6, windSpeedMax: 5.5)])
        
        let station = Station(piouPiouData: piouPiouData)
        XCTAssertEqual(station, expectedStation)
    }

    func testConversionFromPiouPiouNoMeasurement() {
        piouPiouData.measurements.date = nil
        let station = Station(piouPiouData: piouPiouData)
        XCTAssertEqual(station.measurements, [])
    }
    func testConversionFromPiouPiouNoLatitude() {
        piouPiouData.location.latitude = nil
        let station = Station(piouPiouData: piouPiouData)
        XCTAssertEqual(station.latitude, 0)
    }
    func testConversionFromPiouPiouNoLongitude() {
        piouPiouData.location.longitude = nil
        let station = Station(piouPiouData: piouPiouData)
        XCTAssertEqual(station.longitude, 0)
    }
    func testConversionFromArrayOfPiouPiou() {
        let stations = [Station](piouPiouDatas: [piouPiouData, piouPiouData])
        let station = Station(piouPiouData: piouPiouData)
        XCTAssertEqual(stations, [station, station])
    }

}
