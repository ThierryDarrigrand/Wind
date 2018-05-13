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
            // TODO: Date
            //            let RFC3339DateFormatter = DateFormatter()
            //            //RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
            //            RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            //            RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            //
            //            /* 39 minutes and 57 seconds after the 16th hour of December 19th, 1996 with an offset of -08:00 from UTC (Pacific Standard Time) */
            //            //let string = "1996-12-19T16:39:57-08:00"
            //            let string = "2015-08-18T08:19:46"
            //
            //            let date = RFC3339DateFormatter.date(from: string)
            
            //             let formatter = ISO8601DateFormatter()
            //             formatter.formatOptions = [.withYear, .withMonth, .withDay, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
            //            decoder.dateDecodingStrategy = .formatted(formatter)
            
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
