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

private func fetchStations(onComplete completionHandler:(@escaping (Result<PiouPiouStations, Error>) -> Void)) {
    let fileURL = Bundle.main.url(forResource: "PiouPiouMeta", withExtension: "json")
    let data = try! Data(contentsOf: fileURL!)
    let resource = PiouPiouEndPoints.live()
    let result = resource.parse(data)!
    completionHandler(.success(result))
}

private func fetchArchive(stationID:Int, onComplete completionHandler:(@escaping (Result<PiouPiouArchive, Error>) -> Void)) {
    let fileURL = Bundle.main.url(forResource: "PiouPiouArchive", withExtension: "csv")
    let data = try! Data(contentsOf: fileURL!)
    let resource = PiouPiouEndPoints.archive(stationID: 563)
    let result = resource.parse(data)!
    completionHandler(.success(result))
}

extension AeMet {
    static let mock = AeMet(
        fetch: fetch(onComplete:),
        fetchDatas: fetchDatas(url:onComplete:)
    )
}

private func fetch(onComplete completionHandler:@escaping ((Result<AEMETResponseSuccess, Error>) -> Void)) {
    let data = """
    {
    "descripcion": "Éxito",
    "estado": 200,
    "datos": "https://www.apple.com",
    "metadatos": "https://www.apple.com"
    }
    """.data(using: .utf8)!
    let resource = AEMETEndPoints.observacionConvencionalTodas()
    let result = resource.parse(data)!
    completionHandler(.success(result))
}

private func fetchDatas(url:URL, onComplete completionHandler:  @escaping ((Result<[AEMETDatos], Error>) -> Void)) {
    let fileURL = Bundle.main.url(forResource: "Aemet", withExtension: "json")
    let data = try! Data(contentsOf: fileURL!)
    let resource = AEMETEndPoints.datos(url: url)
    let result = resource.parse(data)!
    completionHandler(.success(result))
}

