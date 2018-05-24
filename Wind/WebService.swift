//
//  WebService.swift
//  Wind
//
//  Created by Thierry Darrigrand on 12/05/2018.
//  Copyright © 2018 Thierry Darrigrand. All rights reserved.
//

import Foundation
enum Either<A, B> {
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

public final class Webservice {
    public static func load<A>(_ resource: Resource<A>, completion: @escaping (A?) -> ()) {
        URLSession.shared.dataTask(with: resource.url) { (data, response, error) in
            switch Either(data: data, response: response, error: error) {
            case let .right(data, response):
                let resp = response as! HTTPURLResponse
                if resp.statusCode == 200 {
                    completion(resource.parse(data))
                } else {
                    // erreur de requete
                    print("statusCode: ", resp.statusCode)
                    print(String(data: data, encoding:.utf8)!)
                }
                
            // erreur de connection
            case let .left(error, _):
                print("error:", error)
            }
            }.resume()
    }
}

public struct Resource<A:Decodable> {
    let url: URL
    let parse: (Data) -> A?
}

extension Resource {
    public init(url: URL, _ type: A.Type) {
        var response: A?
        self.url = url
        self.parse = { data in
            let decoder = JSONDecoder()

            let piouPiouDateFormatter = DateFormatter()
            piouPiouDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.zzzZ" // 2018-05-24T09:23:32.000Z
            decoder.dateDecodingStrategy = .formatted(piouPiouDateFormatter)

            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                response = try decoder.decode(type, from: data)
            }
            catch {
                // erreur de decodage du json
                print(error)
            }
            return response
        }
    }
}
