//
//  DateFormatterTests.swift
//  WindTests
//
//  Created by Thierry Darrigrand on 27/05/2018.
//  Copyright © 2018 Thierry Darrigrand. All rights reserved.
//

import XCTest
@testable import Wind

class DateFormatterTests: XCTestCase {
    
    func testPiouPiouDateFormatter() {
        let json = "2018-05-24T09:23:32.000Z"
        let date = Date(timeIntervalSinceReferenceDate: 548846612)
        XCTAssertEqual(date,  PiouPiouEndPoints.dateFormatter.date(from:json))
        XCTAssertEqual(json, PiouPiouEndPoints.dateFormatter.stringZ(from: date))
    }
    func testAemetDateFormatter() {
        let json = "2018-05-24T09:23:32"
        let date = Date(timeIntervalSinceReferenceDate: 548846612)
        XCTAssertEqual(date,  AEMETEndPoints.dateFormatter.date(from:json))
        XCTAssertEqual(json, AEMETEndPoints.dateFormatter.string(from: date))

    }
}

