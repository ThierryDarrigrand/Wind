//
//  PiouPiouEndPointsTests.swift
//  WindTests
//
//  Created by Thierry Darrigrand on 31/05/2018.
//  Copyright © 2018 Thierry Darrigrand. All rights reserved.
//

import XCTest
@testable import Wind

class PiouPiouEndPointsTests: XCTestCase {
    // TODO: tester url (y compris AemetEndPoints
    let id = 563
    lazy var startDate = Date(timeIntervalSinceReferenceDate: 549620700) // 2018-06-02T08:25:00.000Z
    lazy var stopDate = Date(timeInterval: 3600, since: startDate)

    func testArchiveURLTwoDates() {
        let url = PiouPiouEndPoints.archive(
            stationID: id,
            startDate:.date(startDate),
            stopDate: .date(stopDate)
            ).url

        let expectedURL = URL(string: "http://api.pioupiou.fr/v1/archive/563?start=2018-06-02T08:25:00.000Z&stop=2018-06-02T09:25:00.000Z&format=csv")
        XCTAssertEqual(url, expectedURL)
    }
    
    func testArchiveURLLastHour() {
        let url = PiouPiouEndPoints.archive(
            stationID: id,
            startDate: .lastHour,
            stopDate:  .date(stopDate)
            ).url
        
        let expectedURL = URL(string: "http://api.pioupiou.fr/v1/archive/563?start=last-hour&stop=2018-06-02T09:25:00.000Z&format=csv")
        XCTAssertEqual(url, expectedURL)
    }
    func testArchiveURLLastDay() {
        let url = PiouPiouEndPoints.archive(
            stationID: id,
            startDate:.lastDay,
            stopDate: .date(stopDate)
            ).url
        
        let expectedURL = URL(string: "http://api.pioupiou.fr/v1/archive/563?start=last-day&stop=2018-06-02T09:25:00.000Z&format=csv")
        XCTAssertEqual(url, expectedURL)
    }
    func testArchiveURLLastWeek() {
        let url = PiouPiouEndPoints.archive(
            stationID: id,
            startDate: .lastWeek,
            stopDate: .date(stopDate)
            ).url

        let expectedURL = URL(string: "http://api.pioupiou.fr/v1/archive/563?start=last-week&stop=2018-06-02T09:25:00.000Z&format=csv")
        XCTAssertEqual(url, expectedURL)
    }
    func testArchiveURLLastMonth() {
        let url = PiouPiouEndPoints.archive(
            stationID: id,
            startDate: .lastMonth,
            stopDate: .date(stopDate)
            ).url

        let expectedURL = URL(string: "http://api.pioupiou.fr/v1/archive/563?start=last-month&stop=2018-06-02T09:25:00.000Z&format=csv")
        XCTAssertEqual(url, expectedURL)
    }
    func testArchiveURLNow() {
        let url = PiouPiouEndPoints.archive(
            stationID: id,
            startDate:.date(startDate),
            stopDate: .now
            ).url

        let expectedURL = URL(string: "http://api.pioupiou.fr/v1/archive/563?start=2018-06-02T08:25:00.000Z&stop=now&format=csv")
        XCTAssertEqual(url, expectedURL)
    }
    
    // a transferer dans PiouPiouTests
    func testArchiveEmptyParseSuccess() {
        let data = """
"License","http://developers.pioupiou.fr/data-licensing"
"Attribution","(c) contributors of the Pioupiou wind network <http://pioupiou.fr>"
"time","latitude","longitude","wind_speed_min","wind_speed_avg","wind_speed_max","wind_heading","pressure"
"utc","degrees","degrees","km/h","km/h","km/h","degrees","(deprecated)"
""".data(using: .utf8)!

        let archive = PiouPiouEndPoints.archive(
            stationID: id,
            startDate:.date(startDate),
            stopDate: .date(stopDate)
            ).parse(data)
        
        let expectedArchive = PiouPiouArchive(
            doc: nil,
            license: "http://developers.pioupiou.fr/data-licensing",
            attribution: "(c) contributors of the Pioupiou wind network <http://pioupiou.fr>",
            legend: ["time", "latitude", "longitude", "wind_speed_min", "wind_speed_avg", "wind_speed_max", "wind_heading", "pressure"],
            units: ["utc", "degrees", "degrees", "km/h", "km/h", "km/h", "degrees", "(deprecated)"],
            data: [])
        
        XCTAssertEqual(archive, expectedArchive)
    }

    
    func testLiveURLStationID() {
        let url = PiouPiouEndPoints.live(withMeta: false, stationId: id).url
        let expectedURL = URL(string: "http://api.pioupiou.fr/v1/live/563")
        XCTAssertEqual(url, expectedURL)
    }
    func testLiveURLWithMetaStationID() {
        let url = PiouPiouEndPoints.live(withMeta: true, stationId: id).url
        let expectedURL = URL(string: "http://api.pioupiou.fr/v1/live-with-meta/563")
        XCTAssertEqual(url, expectedURL)
    }
    func testLiveURLStationAll() {
        let url = PiouPiouEndPoints.live(withMeta: false).url
        let expectedURL = URL(string: "http://api.pioupiou.fr/v1/live/all")
        XCTAssertEqual(url, expectedURL)
    }
    func testLiveURLStationWithMetaAll() {
        let url = PiouPiouEndPoints.live(withMeta: true).url
        let expectedURL = URL(string: "http://api.pioupiou.fr/v1/live-with-meta/all")
        XCTAssertEqual(url, expectedURL)
    }

}

extension Array where Element == PiouPiouArchive.Measurement {
    init(ids:[Int], timeIntervals: [Double], since startDate:Date, latitudes: [Double], longitudes: [Double], windSpeedMins: [Double],  windSpeedAvgs: [Double], windSpeedMaxs: [Double], windHeadings: [Double], pressures: [Double?]) {
        
        var measurements: [Element] = []
        for ((((((((id, timeInterval), latitude), longitude), windSpeedMin), windSpeedAvg), windSpeedMax), windHeading), pressure) in zip(zip(zip(zip(zip(zip(zip(zip(ids, timeIntervals), latitudes), longitudes), windSpeedMins), windSpeedAvgs), windSpeedMaxs), windHeadings), pressures) {
            measurements += [.init(
                id: id,
                date: Date(timeInterval: timeInterval, since: startDate),
                latitude: latitude,
                longitude: longitude,
                windSpeedMin: windSpeedMin,
                windSpeedAvg: windSpeedAvg,
                windSpeedMax: windSpeedMax,
                windHeading: windHeading,
                pressure: pressure)
            ]
        }
        self = measurements        
    }
}

