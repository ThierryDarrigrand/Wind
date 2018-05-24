//
//  Environment.swift
//  Wind
//
//  Created by Thierry Darrigrand on 24/05/2018.
//  Copyright © 2018 Thierry Darrigrand. All rights reserved.
//

import Foundation

struct Environment {
//    var analytics = Analytics()
    var date: () -> Date = Date.init
    var piouPiouWebService:PiouPiouWebService = PiouPiouWebService()
    var aemetWebService:AEMETWebService = .mock //AEMETWebService()
}

extension Environment {
    static let mock = Environment(
        date: { Date(timeIntervalSinceReferenceDate: 557152051) },
        piouPiouWebService: .mock,
        aemetWebService: .mock
    )
}
