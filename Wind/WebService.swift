//
//  WebService.swift
//  Wind
//
//  Created by Thierry Darrigrand on 12/05/2018.
//  Copyright © 2018 Thierry Darrigrand. All rights reserved.
//

import Foundation

enum Result<Value, Error> {
    case success(Value)
    case failure(Error)
}

struct PiouPiou {
    var fetchStations: (@escaping ((Result<PiouPiouStations, Error>) -> Void)) -> ()
    var fetchArchive: (Int, @escaping ((Result<PiouPiouArchive, Error>) -> Void)) -> ()
    
    static let live = PiouPiou(
        fetchStations: fetchStations(onComplete:),
        fetchArchive: fetchArchive(stationID:onComplete:)
    )
}

private func fetchStations(onComplete completionHandler:(@escaping (Result<PiouPiouStations, Error>) -> Void)) {
    let resource = PiouPiouEndPoints.live()
    load(resource, completion: completionHandler)
}

private func fetchArchive(stationID:Int, onComplete completionHandler:(@escaping (Result<PiouPiouArchive, Error>) -> Void)) {
    let resource = PiouPiouEndPoints.archive(stationID: stationID)
    load(resource, completion: completionHandler)
}


struct AeMet {
    var fetch: (@escaping ((Result<AEMETResponseSuccess, Error>) -> Void)) -> ()
    var fetchDatas: (URL, @escaping ((Result<[AEMETDatos], Error>) -> Void)) -> ()
    
    static let live = AeMet(
        fetch: fetch(onComplete:),
        fetchDatas: fetchDatas(url:onComplete:)
    )
}
private func fetch(onComplete completionHandler: (@escaping (Result<AEMETResponseSuccess, Error>) -> Void)) {
    let resource = AEMETEndPoints.observacionConvencionalTodas()
    load(resource, completion: completionHandler)
}
private func fetchDatas(url:URL, onComplete completionHandler: (@escaping (Result<[AEMETDatos], Error>) -> Void)) {
    let resource = AEMETEndPoints.datos(url: url)
    load(resource, completion: completionHandler)
}

extension AeMet {
    static let mock = AeMet(
        fetch: {callback in
            let response = AEMETResponseSuccess(
                descripcion:"Éxito",
                estado:200,
                datos: URL(string: "https://www.apple.com")!,
                metadatos:URL(string: "https://www.apple.com")!
            )
            callback(.success(response))
    },
        fetchDatas: { url , callback in
            let fileURL = Bundle.main.url(forResource: "Aemet", withExtension: "json")
            let data = try! Data(contentsOf: fileURL!)
            let result = AEMETEndPoints.datos(url: url).parse(data)!
            callback(.success(result))
    })
}

private enum Either<A, B> {
    case right(A)
    case left(B)
}
extension Either where A == (Data, URLResponse), B == (Error, URLResponse?) {
    /// convert (Data?, URLResponse?, Error?) into
    /// Either<(Data, URLResponse), (Error, URLResponse?)>
    fileprivate init(data: Data?, response: URLResponse?, error: Error?) {
        switch (data, response, error) {
        case let (data?, response?, _):
            self = .right((data, response))
        case let (_, response, error?):
            self = .left((error, response))
        default:
            fatalError("Impossible")
        }
    }
}

private func load<A>(_ resource: Resource<A>, completion: @escaping (Result<A, Error>) -> ()) {
    URLSession.shared.dataTask(with: resource.url) { (data, response, error) in
        switch Either(data: data, response: response, error: error) {
        case let .right(data, response):
            let resp = response as! HTTPURLResponse
            if resp.statusCode == 200 {
                if let data = resource.parse(data) {
                    completion(.success(data))
                } else {
                    let error = NSError(domain: "Parse error", code: 1, userInfo: [NSLocalizedDescriptionKey: "Oops"])
                    completion(.failure(error))
                }
            } else {
                // erreur de requete
                let error = NSError(domain: resource.url.host!, code: 1, userInfo: [NSLocalizedDescriptionKey: "statusCode: \(resp.statusCode), data:\(String(data: data, encoding:.utf8)!)"])
                completion(.failure(error))
                //                    print("statusCode: ", resp.statusCode)
                //                    print(String(data: data, encoding:.utf8)!)
            }
            
        // erreur de connection
        case let .left(error, _):
            completion(.failure(error))
            //                print("error:", error)
        }
        }.resume()
}

