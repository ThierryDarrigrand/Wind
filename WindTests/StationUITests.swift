//
//  StationUITests.swift
//  WindTests
//
//  Created by Thierry Darrigrand on 27/05/2018.
//  Copyright © 2018 Thierry Darrigrand. All rights reserved.
//

import XCTest
@testable import Wind

class StationUITests: XCTestCase {
    let station = Station(id: "PiouPiou.19", name: "Porto Rico", latitude: 45, longitude: 20, measurements: [Station.Measurement(date: Date(timeIntervalSinceReferenceDate: 557152051), windHeading: 315, windSpeedAvg: 4.6, windSpeedMax: 5.5)])
    
    func testTitle() {
        XCTAssertEqual(station.title, "Porto Rico - PiouPiou.19")
    }
    
    func testFormattedAngle() {
        XCTAssertEqual(Station.Measurement.formattedAngle(316.5), "NW (316º)")
    }
    func testFormattedSpeed() {
        XCTAssertEqual(Station.Measurement.formattedSpeed(4.654), "4.6 km/h")
    }
}
