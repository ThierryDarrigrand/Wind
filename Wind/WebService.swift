//
//  WebService.swift
//  Wind
//
//  Created by Thierry Darrigrand on 12/05/2018.
//  Copyright © 2018 Thierry Darrigrand. All rights reserved.
//

import Foundation

struct PiouPiouWebService {
    var fetchPiouPiou = fetchPiouPiou(onComplete:)
}

private func fetchPiouPiou(onComplete completionHandler:(@escaping (PiouPiouStations?) -> Void)) {
    Webservice.load(PiouPiouEndPoints.allStationsWithMeta(), completion: completionHandler)
}

extension PiouPiouWebService {
    static let mock = PiouPiouWebService(fetchPiouPiou: {callback in
        let fileURL = Bundle.main.url(forResource: "PiouPiouMeta", withExtension: "txt")
        let data = try! Data(contentsOf: fileURL!)
        callback(PiouPiouEndPoints.allStationsWithMeta().parse(data))
    })
}

struct AEMETWebService {
    var fetchAemet = fetchAemet(onComplete:)
    var fetchAemetDatos = fetchAemetDatos(url:onComplete:)
}
private func fetchAemet(onComplete completionHandler: (@escaping (ResponseSuccess?) -> Void)) {
    Webservice.load(AEMETEndPoints.observacionConvencionalTodas(), completion: completionHandler)
}
private func fetchAemetDatos(url:URL, onComplete completionHandler: (@escaping ([AemetDatos]?) -> Void)) {
    Webservice.load(Resource(url: url, [AemetDatos].self, dateFormatter:AEMETEndPoints.dateFormatter), completion: completionHandler)
}

extension AEMETWebService {
    static let mock = AEMETWebService(fetchAemet: { callback in
        let response = ResponseSuccess(descripcion:"Éxito", estado:200, datos: "https://www.apple.com", metadatos:"")
        callback(response)
    }, fetchAemetDatos: { url, callback in
        let fileURL = Bundle.main.url(forResource: "Aemet", withExtension: "txt")
        let data = try! Data(contentsOf: fileURL!)
        callback(Resource(url: url, [AemetDatos].self, dateFormatter:AEMETEndPoints.dateFormatter).parse(data))
    })
}

private enum Either<A, B> {
    case right(A)
    case left(B)
}
extension Either where A == (Data, URLResponse), B == (Error, URLResponse?) {
    /// convert (Data?, URLResponse?, Error?) into
    /// Either<(Data, URLResponse), (Error, URLResponse?)>
    init(data: Data?, response: URLResponse?, error: Error?) {
        switch (data, response, error) {
        case let (data?, response?, _):
            self = .right((data, response))
        case let (_, response, error?):
            self = .left((error, response))
        default:
            fatalError("Unimplemented")
        }
    }
}

final class Webservice {
    static func load<A>(_ resource: Resource<A>, completion: @escaping (A?) -> ()) {
        URLSession.shared.dataTask(with: resource.url) { (data, response, error) in
            switch Either(data: data, response: response, error: error) {
            case let .right(data, response):
                let resp = response as! HTTPURLResponse
                if resp.statusCode == 200 {
                    completion(resource.parse(data))
                } else {
                    // erreur de requete
                    completion(nil)
                    print("statusCode: ", resp.statusCode)
                    print(String(data: data, encoding:.utf8)!)
                }
                
            // erreur de connection
            case let .left(error, _):
                completion(nil)
                print("error:", error)
            }
            }.resume()
    }
}

