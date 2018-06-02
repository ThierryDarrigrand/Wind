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
    func testConversionFromPiouPiouArchive() {
        let archive = PiouPiouArchive(
            doc: nil,
            license: "http://developers.pioupiou.fr/data-licensing",
            attribution: "(c) contributors of the Pioupiou wind network <http://pioupiou.fr>",
            legend: ["time", "latitude", "longitude", "wind_speed_min", "wind_speed_avg", "wind_speed_max", "wind_heading", "pressure"],
            units: ["utc", "degrees", "degrees", "km/h", "km/h", "km/h", "degrees", "(deprecated)"],
            data: [PiouPiouArchive.Measurement](
                ids:[Int](repeating:563, count: 15),
                timeIntervals: [33, 277, 517, 757, 1000, 1240, 1480, 1724, 1964, 2204, 2449, 2689, 2929, 3173, 3413],
                since: Date(timeIntervalSinceReferenceDate: 549620700),
                latitudes:[Double](repeating: 46.371751, count: 15),
                longitudes:[Double](repeating: 5.899987, count: 15),
                windSpeedMins: [4.5, 5.0, 5.25, 4.5, 4.25, 4.25, 4.75, 4.5, 4.5, 3.25, 4.5, 5.5, 4.5, 5.5, 5.5],
                windSpeedAvgs: [6.25, 6.75, 7.0, 7.0, 6.5, 5.75, 6.5, 6.75, 6.75, 6.5, 6.75, 7.75, 7.5, 7.5, 7.75],
                windSpeedMaxs:[8.0, 8.25, 8.75, 8.75, 7.75, 7.0, 8.25, 8.0, 8.25, 8.75, 8.25, 9.75, 10.5, 9.5, 10.0],
                windHeadings: [315.0, 315.0, 315.0, 315.0, 315.0, 315.0, 315.0, 315.0, 315.0, 315.0, 315.0, 315.0, 315.0, 315.0, 315.0],
                pressures: [Double?](repeating: nil, count: 15)
        ) )
        let expectedStation = Station(id: "PiouPiou.563", name: "N/A", latitude: 46.371751, longitude: 5.899987, measurements: archive.data.map{Station.Measurement(date: $0.date, windHeading: $0.windHeading, windSpeedAvg: $0.windSpeedAvg, windSpeedMax: $0.windSpeedMax) })
        let station = Station(piouPiouArchive: archive)
        XCTAssertEqual(station, expectedStation)
    }
    
    func testConversionFromPiouPiouArchiveEmpty() {
        let archive = PiouPiouArchive(
            doc: nil,
            license: "http://developers.pioupiou.fr/data-licensing",
            attribution: "(c) contributors of the Pioupiou wind network <http://pioupiou.fr>",
            legend: ["time", "latitude", "longitude", "wind_speed_min", "wind_speed_avg", "wind_speed_max", "wind_heading", "pressure"],
            units: ["utc", "degrees", "degrees", "km/h", "km/h", "km/h", "degrees", "(deprecated)"],
            data: [])
        let station = Station(piouPiouArchive: archive)
        XCTAssertNil(station)
    }
}
