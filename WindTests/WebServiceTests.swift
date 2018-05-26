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
//    func testLoadSuccess() {
//        let url = URL(string:"http://api.pioupiou.fr/v1/live/19")!
//        Webservice.load(resource(url: url)){ result in
//            XCTAssertNotNil(result, "No data was downloaded.")
//            print(String(data: result!, encoding: .utf8)!)
//            self.expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 10.0)
//    }
//    
//    func testLoadFailure() {
//        let url = URL(string:"http://api.pioupiou.fr/v1/live/0")!
//        Webservice.load(resource(url: url)){ result in
//            XCTAssertNil(result, "Data was downloaded.")
//            self.expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 10.0)
//    }
}
