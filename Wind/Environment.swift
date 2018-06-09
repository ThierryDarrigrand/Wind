//
//  Environment.swift
//  Wind
//
//  Created by Thierry Darrigrand on 24/05/2018.
//  Copyright © 2018 Thierry Darrigrand. All rights reserved.
//

import Foundation

var Current = Environment()

struct Environment {
//    var analytics = Analytics()
    private(set) var date: () -> Date = Date.init
    private(set) var piouPiou = PiouPiou.live
    private(set) var aemet = AeMet.mock // .live

}

