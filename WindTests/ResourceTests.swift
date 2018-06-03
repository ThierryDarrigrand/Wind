//
//  ResourceTests.swift
//  WindTests
//
//  Created by Thierry Darrigrand on 24/05/2018.
//  Copyright © 2018 Thierry Darrigrand. All rights reserved.
//

import XCTest
@testable import Wind
// TODO: a supprimer
class ResourceTests: XCTestCase {
    let url = URL(string:"http://api.pioupiou.fr/v1/live/19")!
    let json =
        """
        {
          "doc": "http://developers.pioupiou.fr/api/live/",
          "license": "http://developers.pioupiou.fr/data-licensing",
          "attribution": "(c) contributors of the Pioupiou wind network <http://pioupiou.fr>",
          "data": {
            "id": 19,
            "meta": {
              "name": "Pioupiou 19"
            },
            "location": {
              "latitude": 0,
              "longitude": 0,
              "date": null,
              "success": false
            },
            "measurements": {
              "date": "2018-05-24T09:23:32.000Z",
              "pressure": null,
              "wind_heading": 315,
              "wind_speed_avg": 0,
              "wind_speed_max": 0,
              "wind_speed_min": 0
            },
            "status": {
              "date": "2018-05-24T09:23:32.000Z",
              "snr": 21.96,
              "state": "on"
            }
          }
        }
        """.data(using: .utf8)!

    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // 2018-05-24T09:23:32.000Z
        return dateFormatter
    }()
    
    let station = PiouPiouSingleStation(
        doc: "http://developers.pioupiou.fr/api/live/",
        license: "http://developers.pioupiou.fr/data-licensing",
        attribution: "(c) contributors of the Pioupiou wind network <http://pioupiou.fr>",
        data: PiouPiouData(
            id: 19,
            meta: PiouPiouData.Meta(
                name: "Pioupiou 19",
                description: nil,
                picture: nil,
                date: nil,
                rating: nil),
            location: PiouPiouData.Location(
                latitude: 0,
                longitude: 0,
                date: nil,
                success: false),
            measurements: PiouPiouData.Measurements(
                date: Date(timeIntervalSinceReferenceDate: 548846612),
                pressure: nil,
                windHeading: 315,
                windSpeedAvg: 0,
                windSpeedMax: 0,
                windSpeedMin: 0),
            status: PiouPiouData.Status(
                date: Date(timeIntervalSinceReferenceDate: 548846612),
                snr: 21.96,
                state: "on")
        )
    )
    
    var resource:Resource<PiouPiouSingleStation> {
        return Resource(url: url, PiouPiouSingleStation.self, dateFormatter: dateFormatter)
    }
    
    func testURL() {
        XCTAssertEqual(resource.url, url)
    }

    func testParseSuccess() {
        XCTAssertEqual(resource.parse(json)!, station)
    }
    
    func testParseFailure() {
        XCTAssertNil(resource.parse("abc".data(using: .utf8)!))
    }
    
}
