//
//  Resource.swift
//  Wind
//
//  Created by Thierry Darrigrand on 24/05/2018.
//  Copyright © 2018 Thierry Darrigrand. All rights reserved.
//

import Foundation
struct Resource<A:Decodable> {
    let url: URL
    let parse: (Data) -> A?
}

extension Resource {
    init(url: URL, _ type: A.Type, dateFormatter: DateFormatter) {
        self.url = url
        self.parse = { data in
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                return try decoder.decode(type, from: data)
            }
            catch {
                // erreur de decodage du json
                print(error)
                return nil
            }
        }
    }
}
