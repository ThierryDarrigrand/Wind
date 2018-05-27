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
        let date = PiouPiouEndPoints.dateFormatter.date(from:json)
        XCTAssertEqual(date,  Date(timeIntervalSinceReferenceDate: 548846612))
    }
    func testAemetDateFormatter() {
        let json = "2018-05-24T09:23:32"
        let date = AEMETEndPoints.dateFormatter.date(from:json)
        XCTAssertEqual(date,  Date(timeIntervalSinceReferenceDate: 548846612))
    }

    
}
