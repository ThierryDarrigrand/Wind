//
//  Support.swift
//  WindTests
//
//  Created by Thierry Darrigrand on 03/06/2018.
//  Copyright © 2018 Thierry Darrigrand. All rights reserved.
//

import Foundation
@testable import Wind

extension Environment {
    static let mock = Environment(
        date: { .mock },
        piouPiou: .mock,
        aemet: .mock
    )
}

extension Date {
    static let mock = Date(timeIntervalSinceReferenceDate: 549620700)  // 2018-06-02T08:25:00.000Z
}

extension PiouPiou {
    static let mock = PiouPiou(
        fetchStations: fetchStations(onComplete:),
        fetchArchive: fetchArchive(stationID:onComplete:)
    )
}
extension PiouPiouStations {
    static let mock: PiouPiouStations = {
        let fileURL = Bundle.main.url(forResource: "PiouPiouMeta", withExtension: "json")
        let data = try! Data(contentsOf: fileURL!)
        let resource = PiouPiouEndPoints.live()
        return resource.parse(data)!
    }()
}
private func fetchStations(onComplete completionHandler:(@escaping (Result<PiouPiouStations, Error>) -> Void)) {
    completionHandler(.success(.mock))
}

extension PiouPiouArchive {
    static let mock: PiouPiouArchive = {
        let fileURL = Bundle.main.url(forResource: "PiouPiouArchive", withExtension: "csv")
        let data = try! Data(contentsOf: fileURL!)
        let resource = PiouPiouEndPoints.archive(stationID: 563)
        return resource.parse(data)!
    }()
}

private func fetchArchive(stationID:Int, onComplete completionHandler:(@escaping (Result<PiouPiouArchive, Error>) -> Void)) {
    completionHandler(.success(.mock))
}

extension AeMet {
    static let mock = AeMet(
        fetchDatas: { callback in
            let fileURL = Bundle.main.url(forResource: "Aemet", withExtension: "json")
            let data = try! Data(contentsOf: fileURL!)
            let resource = Resource(url: .mock, [AEMETDatos].self, dateFormatter: AEMETEndPoints.dateFormatter)
            let result = resource.parse(data)!
            callback(.success(result))
    })
}

extension URL {
    static let mock = URL(string: "https://www.apple.com")!
}
extension NSError {
    static let mock = NSError(domain: "Parse Error", code: 1, userInfo: [NSLocalizedDescriptionKey: "Oops"])
}

extension Array where Element == AEMETDatos {
    static let mock: [AEMETDatos] = {
        let fileURL = Bundle.main.url(forResource: "Aemet", withExtension: "json")
        let data = try! Data(contentsOf: fileURL!)
        let resource = Resource(url: .mock, [AEMETDatos].self, dateFormatter: AEMETEndPoints.dateFormatter)
        return resource.parse(data)!
    }()
}


