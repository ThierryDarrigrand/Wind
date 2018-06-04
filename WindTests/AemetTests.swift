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
        AppEnvironment.push{ _ in Environment.mock }
    }
    
    override func tearDown() {
        super.tearDown()
        AppEnvironment.pop()
    }
    
    func testAemetFetchSuccess() {
        let expectedResult = AEMETResponseSuccess(descripcion: "Éxito", estado: 200, datos: URL(string: "https://www.apple.com")!, metadatos: URL(string: "https://www.apple.com")!)
        AppEnvironment.current.aemet.fetch { result in
            guard case .success(let result) = result else { XCTAssert(false) ; return }
            XCTAssertEqual(result, expectedResult)
        }
    }
    
    func testAemetFetchDatas() {
        AppEnvironment.current.aemet.fetchDatas(URL(string: "https://www.apple.com")!){ result in
            guard case .success(let aemetDatas) = result else { XCTAssert(false) ; return }
            XCTAssertEqual(aemetDatas.count, 18208)
        }
    }

    let expectedError = NSError(domain: "Parse Error", code: 1, userInfo: [NSLocalizedDescriptionKey: "Oops"])

    func testAemeteFetchFailure() {
        func fetchFailure(onComplete completionHandler:@escaping ((Result<AEMETResponseSuccess, Error>) -> Void)) {
            let data = "abc".data(using: .utf8)!
            let resource = AEMETEndPoints.observacionConvencionalTodas()
            XCTAssertNil(resource.parse(data))
            completionHandler(.failure(expectedError))
        }

        func fetchDatasFailure(url:URL, onComplete completionHandler:  @escaping ((Result<[AEMETDatos], Error>) -> Void)) {
            let data = "abc".data(using: .utf8)!
            let resource = AEMETEndPoints.datos(url: url)
            XCTAssertNil(resource.parse(data))
            completionHandler(.failure(expectedError))
        }
        let aemetFailure = AeMet(fetch: fetchFailure(onComplete:), fetchDatas: fetchDatasFailure(url:onComplete:))

        AppEnvironment.push { env in
            Environment(date: env.date, piouPiou: env.piouPiou, aemet: aemetFailure)
        }
        AppEnvironment.current.aemet.fetch{ result in
            guard case .failure(let error as NSError) = result else { XCTAssert(false) ; return }
            XCTAssertEqual(error, self.expectedError)
        }
        AppEnvironment.current.aemet.fetchDatas(URL(string: "https://www.apple.com")!){ result in
            guard case .failure(let error as NSError) = result else { XCTAssert(false) ; return }
            XCTAssertEqual(error, self.expectedError)
        }

        AppEnvironment.pop()
    }
    
 }
