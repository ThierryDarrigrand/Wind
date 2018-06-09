//
//  WebServiceTests.swift
//  WindTests
//
//  Created by Thierry Darrigrand on 24/05/2018.
//  Copyright © 2018 Thierry Darrigrand. All rights reserved.
//

import XCTest
@testable import Wind


class AeMetTests: XCTestCase {
    override func setUp() {
        super.setUp()
        Current = .mock
    }
    
    override func tearDown() {
        super.tearDown()
    }
        
    func testAemetFetchDatas() {
        Current.aemet.fetchDatas(){ result in
            guard case .success(let aemetDatas) = result else { XCTAssert(false) ; return }
            XCTAssertEqual(aemetDatas, .mock)
        }
    }

    func testAemeteFetchFailure() {
        func fetchDatasFailure(onComplete completionHandler:  @escaping ((Result<[AEMETDatos], Error>) -> Void)) {
            let data = "abc".data(using: .utf8)!
            let resource = Resource(url: .mock, [AEMETDatos].self, dateFormatter: AEMETEndPoints.dateFormatter)
            XCTAssertNil(resource.parse(data))
            completionHandler(.failure(NSError.mock))
        }
        let aemetFailure = AeMet(fetchDatas: fetchDatasFailure(onComplete:))
        Current = Environment(date: Current.date, piouPiou: Current.piouPiou, aemet: aemetFailure)
        Current.aemet.fetchDatas(){ result in
            guard case .failure(let error as NSError) = result else { XCTAssert(false) ; return }
            XCTAssertEqual(error, NSError.mock)
        }
    }
    
 }
