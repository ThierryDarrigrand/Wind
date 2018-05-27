//
//  WebServiceTests.swift
//  WindTests
//
//  Created by Thierry Darrigrand on 24/05/2018.
//  Copyright © 2018 Thierry Darrigrand. All rights reserved.
//

import XCTest
@testable import Wind

class WebServiceTests: XCTestCase {
    let expectation = XCTestExpectation(description: "Download pioupiou data")
    private func resource(url:URL)->Resource<Data> {
        return Resource(url: url){$0}
    }
    
    func testPiouPiouFetchStationsSuccess() {
        let resource = PiouPiouEndPoints.allStationsWithMeta() // not used
        PiouPiou.mock.fetchStations(resource) {result in
            guard case .success(let piouPiouStations) = result else { return }
            XCTAssertEqual(piouPiouStations.doc, "http://developers.pioupiou.fr/api/live/")
            XCTAssertEqual(piouPiouStations.license, "http://developers.pioupiou.fr/data-licensing")
            XCTAssertEqual(piouPiouStations.attribution, "(c) contributors of the Pioupiou wind network <http://pioupiou.fr>")
            XCTAssertEqual(piouPiouStations.data.count, 385)
        }
    }
    
    
    func testPiouPiouFetchStationsFailure() {
        let expectedError = NSError(domain: "Wind JSON Conversion", code: 1, userInfo: [NSLocalizedDescriptionKey: "Oops"])
        let piouPiouFailure = PiouPiou(fetchStations: {_, callback in
            callback(.failure(expectedError))
        })
    
        let resource = PiouPiouEndPoints.allStationsWithMeta() // not used
        piouPiouFailure.fetchStations(resource) {result in
            guard case .failure(let error as NSError) = result else { return }
            XCTAssertEqual(error, expectedError)
        }
    }

 }
