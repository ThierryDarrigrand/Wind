//
//  Station+UI.swift
//  Wind
//
//  Created by Thierry Darrigrand on 26/05/2018.
//  Copyright © 2018 Thierry Darrigrand. All rights reserved.
//

import Foundation

extension Station {
    var title: String {
        return "\(name) - \(id)"
    }
}

enum WindDirection: Int, CustomStringConvertible {
    var description: String {
        switch self {
        case .N:   return "N"
        case .NNE: return "NNE"
        case .NE:  return "NE"
        case .ENE: return "ENE"
        case .E:   return "E"
        case .ESE: return "ESE"
        case .SE:  return "SE"
        case .SSE: return "SSE"
        case .S:   return "S"
        case .SSW: return "SSW"
        case .SW:  return "SW"
        case .WSW: return "WSW"
        case .W:   return "W"
        case .WNW: return "WNW"
        case .NW:  return "NW"
        case .NNW: return "NNW"
        }
    }
    
    case N, NNE, NE, ENE, E, ESE, SE, SSE, S, SSW, SW, WSW, W, WNW, NW, NNW
    init(angle: Double) {
        let n = Int(round(angle/22.5)) % 16
        self = WindDirection(rawValue: n)!
    }
    
}

extension Station.Measurement {
    static var UIFormatter: DateFormatter = {
        let newFormatter = DateFormatter()
        newFormatter.dateStyle = .medium
        newFormatter.timeStyle = .medium
        return newFormatter
    }()
    
    var formattedDate: String {
        return Station.Measurement.UIFormatter.string(from: date)
    }
    
    static func formattedSpeed(_ speed: Double)->String {
        return "\(Double(Int(speed*10))/10) km/h"
    }
    
    static func formattedAngle(_ angle: Double)->String {
        return "\(WindDirection(angle: angle)) (\(Int(angle))º)"
    }
    
}
