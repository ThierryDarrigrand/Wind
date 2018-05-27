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
    var fetchStations = fetchStations(resource:onComplete:)
}

private func fetchStations(resource: Resource<PiouPiouStations>, onComplete completionHandler:(@escaping (Result<PiouPiouStations, Error>) -> Void)) {
    load(resource, completion: completionHandler)
}

extension PiouPiou {
    static let mock = PiouPiou(fetchStations:{_, callback in
        let fileURL = Bundle.main.url(forResource: "PiouPiouMeta", withExtension: "txt")
        let data = try! Data(contentsOf: fileURL!)
        let resource = PiouPiouEndPoints.allStationsWithMeta()
        let result = resource.parse(data)!
        callback(.success(result))
    })
}

struct AeMet {
    var fetch = fetch(resource:onComplete:)
    var fetchDatas = fetchDatas(resource:onComplete:)
}
private func fetch(resource:Resource<ResponseSuccess>, onComplete completionHandler: (@escaping (Result<ResponseSuccess, Error>) -> Void)) {
    load(resource, completion: completionHandler)
}
private func fetchDatas(resource:Resource<[AemetDatos]>, onComplete completionHandler: (@escaping (Result<[AemetDatos], Error>) -> Void)) {
    load(resource, completion: completionHandler)
}

extension AeMet {
    static let mockURL = URL(string: "https://www.apple.com")!
    static let mock = AeMet(fetch: {_, callback in
        let response = ResponseSuccess(descripcion:"Éxito", estado:200, datos: mockURL.absoluteString, metadatos:"")
        callback(.success(response))
    }, fetchDatas: { _ , callback in
        let fileURL = Bundle.main.url(forResource: "Aemet", withExtension: "txt")
        let data = try! Data(contentsOf: fileURL!)
        let result = AEMETEndPoints.datos(url: mockURL).parse(data)!
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
                    let error = NSError(domain: "Wind JSON Conversion", code: 1, userInfo: [NSLocalizedDescriptionKey: "Oops"])
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

