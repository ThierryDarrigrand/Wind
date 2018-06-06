//
//  Resource.swift
//  Wind
//
//  Created by Thierry Darrigrand on 24/05/2018.
//  Copyright © 2018 Thierry Darrigrand. All rights reserved.
//

import Foundation
import os

struct Resource<A> {
    let url: URL
    let parse: (Data) -> A?
}

extension Resource where A:Decodable {
    init(url: URL, _ type: A.Type, dateFormatter: DateFormatter) {
        self.url = url
        self.parse = parseJSON(type, dateFormatter)
    }
}


private func parseJSON<A:Decodable>(_ type: A.Type, _ dateFormatter: DateFormatter)-> (Data) -> A? {
    return { data in
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(type, from: data)
        }
        catch {
            // erreur de decodage du json
            print(error)
//            os_log(error as! StaticString)
            return nil
        }
    }
}
