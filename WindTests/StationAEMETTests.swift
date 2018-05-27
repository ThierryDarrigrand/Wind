//
//  StationAEMETTests.swift
//  WindTests
//
//  Created by Thierry Darrigrand on 27/05/2018.
//  Copyright © 2018 Thierry Darrigrand. All rights reserved.
//

import XCTest
@testable import Wind

class StationAEMETTests: XCTestCase {
    
    var aemetData = AemetDatos(
        idema: "ST5XF",
        lon: 20,
        lat: 45,
        alt: 20.3,
        ubi: "Porto Rico",
        fint: Date(timeIntervalSinceReferenceDate: 557152051),
        prec: nil, pacutp: nil, pliqtp: nil, psolt: nil,
        vmax: 3.2,
        vv: 4.3,
        vmaxu: nil, vvu: nil,
        dv: 46.4,
        dvu: nil, dmax: nil, dmaxu: nil, stdvv: nil, stddv: nil, stdvvu: nil, stddvu: nil, hr: nil, inso: nil, pres: nil, presNmar: nil, ts: nil, tss20cm: nil, tss5cm: nil, ta: nil, tpr: nil, tamin: nil, tamax: nil, vis: nil, geo700: nil, geo850: nil, geo925: nil, rviento: nil, nieve: nil
    )
    
    func testConversionFromAemet() {
        let measurement = Station.Measurement(date: Date(timeIntervalSinceReferenceDate: 557152051), windHeading: 46.4, windSpeedAvg: 4.3*3.6, windSpeedMax: 3.2*3.6)
        let expectedStation = Station(id: "Aemet.ST5XF", name: "Porto Rico", latitude: 45, longitude: 20, measurements: [measurement])
        let station = Station(aemetDatos: aemetData)
        XCTAssertEqual(station, expectedStation)
    }
    func testConversionFromAemetNoFint() {
        aemetData.fint = nil
        let station = Station(aemetDatos: aemetData)
        XCTAssertEqual(station.measurements, [])
    }
    func testConversionFromAemetNoVMax() {
        aemetData.vmax = nil
        let station = Station(aemetDatos: aemetData)
        XCTAssertNil(station.measurements[0].windSpeedMax)
    }
    func testConversionFromAemetNoVV() {
        aemetData.vv = nil
        let station = Station(aemetDatos: aemetData)
        XCTAssertNil(station.measurements[0].windSpeedAvg)
    }
    func testConversionFromArrayOfAemet() {
        var aemetData2 = aemetData
        aemetData2.fint = Date(timeInterval: 3600, since: aemetData.fint!)
        
        var aemetData3 = aemetData
        aemetData3.idema = "ABCDE"
        
        var station1 = Station(aemetDatos: aemetData)
        
        var measurement2 = station1.measurements[0]
        measurement2.date = Date(timeInterval: 3600, since:measurement2.date)
        station1.measurements += [measurement2]
        
        let station2 = Station(aemetDatos: aemetData3)

        let stations = [Station](aemetDatas: [aemetData, aemetData2, aemetData3])

        XCTAssertEqual(stations.sorted(by: <), [station2, station1].sorted(by: <))
    }

}
