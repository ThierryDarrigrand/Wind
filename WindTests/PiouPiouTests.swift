//
//  PiouPiouTests.swift
//  WindTests
//
//  Created by Thierry Darrigrand on 04/06/2018.
//  Copyright © 2018 Thierry Darrigrand. All rights reserved.
//

import XCTest
@testable import Wind

class PiouPiouTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        AppEnvironment.push{ _ in Environment.mock }
    }
    
    override func tearDown() {
        super.tearDown()
        AppEnvironment.pop()
    }

    let piouPiouLicense = "http://developers.pioupiou.fr/data-licensing"
    let piouPiouAttribution = "(c) contributors of the Pioupiou wind network <http://pioupiou.fr>"
    
    func testPiouPiouFetchStationsSuccess() {
        AppEnvironment.current.piouPiou.fetchStations() {result in
            guard case .success(let piouPiouStations) = result else { XCTAssert(false) ; return }
//            XCTAssertEqual(piouPiouStations.doc, "http://developers.pioupiou.fr/api/live/")
//            XCTAssertEqual(piouPiouStations.license, self.piouPiouLicense)
//            XCTAssertEqual(piouPiouStations.attribution, self.piouPiouAttribution)
//            XCTAssertEqual(piouPiouStations.data.count, 385)
            XCTAssertEqual(piouPiouStations, .mock)
        }
    }
    // TODO: singleStation
    func testPiouPiouFetchArchiveSuccess() {
//        let expectedArchive = PiouPiouArchive(
//            doc: nil,
//            license: piouPiouLicense,
//            attribution: piouPiouAttribution,
//            legend: ["time", "latitude", "longitude", "wind_speed_min", "wind_speed_avg", "wind_speed_max", "wind_heading", "pressure"],
//            units: ["utc", "degrees", "degrees", "km/h", "km/h", "km/h", "degrees", "(deprecated)"],
//            data: [PiouPiouArchive.Measurement](
//                ids:[Int](repeating:563, count: 15),
//                timeIntervals: [33, 277, 517, 757, 1000, 1240, 1480, 1724, 1964, 2204, 2449, 2689, 2929, 3173, 3413],
//                since: AppEnvironment.current.date(),
//                latitudes:[Double](repeating: 46.371751, count: 15),
//                longitudes:[Double](repeating: 5.899987, count: 15),
//                windSpeedMins: [4.5, 5.0, 5.25, 4.5, 4.25, 4.25, 4.75, 4.5, 4.5, 3.25, 4.5, 5.5, 4.5, 5.5, 5.5],
//                windSpeedAvgs: [6.25, 6.75, 7.0, 7.0, 6.5, 5.75, 6.5, 6.75, 6.75, 6.5, 6.75, 7.75, 7.5, 7.5, 7.75],
//                windSpeedMaxs:[8.0, 8.25, 8.75, 8.75, 7.75, 7.0, 8.25, 8.0, 8.25, 8.75, 8.25, 9.75, 10.5, 9.5, 10.0],
//                windHeadings: [315.0, 315.0, 315.0, 315.0, 315.0, 315.0, 315.0, 315.0, 315.0, 315.0, 315.0, 315.0, 315.0, 315.0, 315.0],
//                pressures: [Double?](repeating: nil, count: 15)
//        ) )
        
        AppEnvironment.current.piouPiou.fetchArchive(563) { result in
            guard case .success(let archive) = result else { XCTAssert(false) ; return }
            XCTAssertEqual(archive, .mock)
        }
    }
    
    let expectedError = NSError(domain: "Parse Error", code: 1, userInfo: [NSLocalizedDescriptionKey: "Oops"])

    func testPiouPiouFetchFailure() {
        func fetchStationsFailure(onComplete completionHandler:@escaping ((Result<PiouPiouStations, Error>) -> Void)) {
            let data = "abc".data(using: .utf8)!
            let resource = PiouPiouEndPoints.live()
            XCTAssertNil(resource.parse(data))
            completionHandler(.failure(expectedError))
        }
        
        func fetchArchiveFailure(stationID:Int, onComplete completionHandler:  @escaping ((Result<PiouPiouArchive, Error>) -> Void)) {
            let data = "abc".data(using: .utf8)!
            let resource = PiouPiouEndPoints.archive(stationID: stationID)
            XCTAssertNil(resource.parse(data))
            completionHandler(.failure(expectedError))
        }
        let piouPiouFailure = PiouPiou(fetchStations: fetchStationsFailure(onComplete:), fetchArchive: fetchArchiveFailure(stationID:onComplete:))
        
        AppEnvironment.push { env in
            Environment(date: env.date, piouPiou: piouPiouFailure, aemet: env.aemet)
        }
        AppEnvironment.current.piouPiou.fetchStations{ result in
            guard case .failure(let error as NSError) = result else { XCTAssert(false) ; return }
            XCTAssertEqual(error, self.expectedError)
        }
        AppEnvironment.current.piouPiou.fetchArchive(563){ result in
            guard case .failure(let error as NSError) = result else { XCTAssert(false) ; return }
            XCTAssertEqual(error, self.expectedError)
        }
        
        AppEnvironment.pop()
    }

}
