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
    
    func testArchiveParseFailure() {
        let archive = PiouPiouEndPoints.archive(
            stationID: id,
            startDate:.date(startDate),
            stopDate: .date(stopDate)
        ).parse("abc".data(using: .utf8)!)
        XCTAssertNil(archive)
    }

    func testArchiveParseSuccess() {
        let data:Data = {
            let fileURL = Bundle.main.url(forResource: "PiouPiouArchive", withExtension: "csv")
            return  try! Data(contentsOf: fileURL!)
        }()
        let count = 15

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
            data: [PiouPiouArchive.Measurement](
                ids:[Int](repeating:id, count: count),
                timeIntervals: [33, 277, 517, 757, 1000, 1240, 1480, 1724, 1964, 2204, 2449, 2689, 2929, 3173, 3413],
                since: startDate,
                latitudes:[Double](repeating: 46.371751, count: count),
                longitudes:[Double](repeating: 5.899987, count: count),
                windSpeedMins: [4.5, 5.0, 5.25, 4.5, 4.25, 4.25, 4.75, 4.5, 4.5, 3.25, 4.5, 5.5, 4.5, 5.5, 5.5],
                windSpeedAvgs: [6.25, 6.75, 7.0, 7.0, 6.5, 5.75, 6.5, 6.75, 6.75, 6.5, 6.75, 7.75, 7.5, 7.5, 7.75],
                windSpeedMaxs:[8.0, 8.25, 8.75, 8.75, 7.75, 7.0, 8.25, 8.0, 8.25, 8.75, 8.25, 9.75, 10.5, 9.5, 10.0],
                windHeadings: [315.0, 315.0, 315.0, 315.0, 315.0, 315.0, 315.0, 315.0, 315.0, 315.0, 315.0, 315.0, 315.0, 315.0, 315.0],
                pressures: [Double?](repeating: nil, count: count)
        ) )
        
        XCTAssertEqual(archive, expectedArchive)
        
    }
    
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

