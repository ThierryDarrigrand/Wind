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
    private(set) var date: () -> Date
    private(set) var piouPiou: PiouPiou
    private(set) var aemet: AeMet
    
    init(
        date: @escaping ()->Date = Date.init,
        piouPiou:PiouPiou = .live,
        aemet: AeMet = .mock // .live 
        ) {
        self.date = date
        self.piouPiou = piouPiou
        self.aemet = aemet
    }
}


struct AppEnvironment {
    private static var stack: [Environment] = [Environment()]
    static var current: Environment { return stack.last! }
    
    static func push(_ env: (Environment) -> Environment) {
        self.stack.append(env(self.current))
    }
    
    static func with(_ env: (Environment) -> Environment, _ block: () -> Void) {
        self.push(env)
        block()
        self.pop()
    }
    
    public static func pop() {
        self.stack.removeLast()
    }
}

