//
//  Aemet.swift
//  Wind
//
//  Created by Thierry Darrigrand on 12/05/2018.
//  Copyright © 2018 Thierry Darrigrand. All rights reserved.
//

import Foundation
struct AEMETDatos: Codable, Equatable {
    /// Indicativo climatógico de la estación meteorológia automática
    var idema: String //"0002I",
    /// Longitud de la estación meteorológica (grados)
    var lon: Double //0.871385,
    /// Latitud de la estación meteorológica (grados)
    var lat: Double //40.95806,
    ///  Altitud de la estación en metros
    var alt: Double //32.0,
    /// Ubicación de la estación. Nombre de la estación
    var ubi: String //"VANDELLÓS",
    /// Fecha hora final del período de observación, se trata de datos del periodo de la hora anterior a la indicada por este campo (hora UTC)
    var fint: Date? // Date "2018-05-09T10:00:00",
    /// Precipitación acumulada, medida por el pluviómetro, durante los 60 minutos anteriores a la hora indicada por el período de observación 'fint' (mm, equivalente a l/m2)
    var prec: Double? //0.0,
    /// Precipitación acumulada, medida por el disdrómetro, durante los 60 minutos anteriores a la hora indicada por el período de observación 'fint' (mm, equivalente a l/m2)
    var pacutp: Double?
    /// Precipitación líquida acumulada durante los 60 minutos anteriores a la hora indicada por el período de observación 'fint' (mm, equivalente a l/m2)
    var pliqtp: Double?
    /// Precipitación sólida acumulada durante los 60 minutos anteriores a la hora indicada por el período de observación 'fint' (mm, equivalente a l/m2)
    var psolt: Double?
    /// Velocidad máxima del viento, valor máximo del viento mantenido 3 segundos y registrado en los 60 minutos anteriores a la hora indicada por el período de observación 'fint' (m/s)
    var vmax: Double? //11.0,
    /// Velocidad media del viento, media escalar de las muestras adquiridas cada 0,25 ó 1 segundo en el período de 10 minutos anterior al indicado por 'fint' (m/s)
    var vv: Double? //3.9,
    /// Velocidad máxima del viento (sensor ultrasónico), valor máximo del viento mantenido 3 segundos y registrado en los 60 minutos anteriores a la hora indicada por el período de observación 'fint' (m/s)
    var vmaxu: Double?
    /// Velocidad media del viento (sensor ultrasónico), media escalar en el periódo de 10 minutos anterior al indicado por 'fint' de las muestras adquiridas cada 0,25 ó 1 segundo (m/s)
    var vvu: Double?
    /// Dirección media del viento, en el período de 10 minutos anteriores a la fecha indicada por 'fint' (grados)
    var dv: Double? //304.0,
    /// Dirección media del viento (sensor ultrasónico), en el período de 10 minutos anteriores a la fecha indicada por 'fint' (grados)
    var dvu: Double?
    /// Dirección del viento máximo registrado en los 60 minutos anteriores a la hora indicada por 'fint' (grados)
    var dmax: Double? //241.0,
    /// Dirección del viento máximo registrado en los 60 minutos anteriores a la hora indicada por 'fint' por el sensor ultrasónico (grados)
    var dmaxu: Double?
    /// Desviación estándar de las muestras adquiridas de velocidad del viento durante los 10 minutos anteriores a la fecha dada por 'fint' (m/s)
    var stdvv: Double? //0.8,
    /// Desviación estándar de las muestras adquiridas de la dirección del viento durante los 10 minutos anteriores a la fecha dada por 'fint' (grados)
    var stddv: Double? //78.0,
    /// Desviación estándar de las muestras adquiridas de velocidad del viento durante los 10 minutos anteriores a la fecha dada por 'fint' obtenido del sensor ultrasónico de viento instalado junto al convencional (m/s)
    var stdvvu: Double?
    /// Desviación estándar de las muestras adquiridas de la dirección del viento durante los 10 minutos anteriores a la fecha dada por 'fint' obtenido del sensor ultrasónico de viento instalado junto al convencional (grados)
    var stddvu: Double?
    /// Humedad relativa instantánea del aire correspondiente a la fecha dada por 'fint' (%)
    var hr: Double? //46.0,
    /// Duración de la insolación durante los 60 minutos anteriores a la hora indicada por el período de observación 'fint' (horas)
    var inso: Double? //60.0
    /// Presión instantánea al nivel en el que se encuentra instalado el barómetro y correspondiente a la fecha dada por 'fint' (hPa)
    var pres: Double? //1000.4,
    /// Valor de la presión reducido al nivel del mar para aquellas estaciones cuya altitud es igual o menor a 750 metros y correspondiente a la fecha indicada por 'fint' (hPa)
    var presNmar: Double? //1009.2,
    /// Temperatura suelo, temperatura instantánea junto al suelo y correspondiente a los 10 minutos anteriores a la fecha dada por 'fint' (grados Celsius)
    var ts: Double? // 28.3,
    /// Temperatura subsuelo 20 cm, temperatura del subsuelo a una profundidad de 20 cm y correspondiente a los 10 minutos anteriores a la fecha dada por 'fint' (grados Celsius)
    var tss20cm: Double?
    /// Temperatura subsuelo 5 cm, temperatura del subsuelo a una profundidad de 5 cm y correspondiente a los 10 minutos anteriores a la fecha dada por 'fint' (grados Celsius)
    var tss5cm: Double?
    /// Temperatura instantánea del aire correspondiente a la fecha dada por 'fint' (grados Celsius)
    var ta: Double? //20.0,
    /// Temperatura del punto de rocío calculado correspondiente a la fecha 'fint' (grados Celsius)
    var tpr: Double? //8.0,
    /// Temperatura mínima del aire, valor mínimo de los 60 valores instantáneos de 'ta' medidos en el período de 60 minutos anteriores a la hora indicada por el período de observación 'fint' (grados Celsius)
    var tamin: Double? //19.0,
    /// Temperatura máxima del aire, valor máximo de los 60 valores instantáneos de 'ta' medidos en el período de 60 minutos anteriores a la hora indicada por el período de observación 'fint' (grados Celsius)
    var tamax: Double? //20.4,
    /// Visibilidad, promedio de la medida de la visibilidad correspondiente a los 10 minutos anteriores a la fecha dada por 'fint' (Km)
    var vis: Double? //29.9,
    /// Altura del nivel de la superficie de referencia barométrica de 700 hPa calculado para las estaciones con altitud mayor de 2300 metros y correspondiente a la fecha indicada por 'fint' (m geopotenciales)
    var geo700: Double?
    struct Geo850: Codable, Equatable {
        var value: Double
        var present: Bool
    }
    /// Altura del nivel de la superficie de referencia barométrica de 850 hPa calculado para las estaciones con altitud mayor de 1000 metros y menor o igual a 2300 metros y correspondiente a la fecha indicada por 'fint' (m geopotenciales)
    var geo850: Geo850?
    /// Altura del nivel de la superficie barométrica de 925 hPa calculado para las estaciones con altitud mayor de 750 metros y y menor o igual a 1000 metros correspondiente a la fecha indicada por 'fint' (m geopotenciales)
    var geo925: Double?
    /// Recorrido del viento durante los 60 minutos anteriores a la fecha indicada por 'fint' (Hm)
    var rviento: Double? //145.0
    /// Espesor de la capa de nieve medid en los 10 minutos anteriores a la a la fecha indicada por 'fint' (cm)
    var nieve: Double?
    
}

struct AEMETInventarioEstaciones: Codable {
    let latitud: String //"431825N",
    let provincia: String //"A CORUÑA",
    let altitud: String //"98",
    let indicativo: String //"1387E",
    let nombre: String // "A CORUÑA AEROPUERTO",
    let indsinop: String //"08002",
    let longitud: String //"082219W"
}


struct AEMETMetaDatos: Codable {
    let unidadGeneradora: String //"Servicio de Observación",
    let periodicidad: String //"continuamente",
    let formato: String //"application/json",
    let copyright: String //"© AEMET. Autorizado el uso de la información y su reproducción citando a AEMET como autora de la misma.",
    let notaLegal: String // URL "http://www.aemet.es/es/nota_legal",
    let campos: [Campo] //[{
    
    struct Campo: Codable {
        let id: String
        let descripcion: String
        let tipo_datos: String
        let requerido: Bool
    }
}

struct AEMETResponseSuccess: Decodable, Equatable {
    let descripcion: String // "Éxito"
    let estado: Int // 200
    let datos: URL
    let metadatos: URL
}

struct AEMETEndPoints {
    static func urlApi(_ api: String) -> URL {
        let baseURL = URL(string: "https://opendata.aemet.es")!
        let api_key = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ2aW5jZW50LmRhcnJpZ3JhbmRAZ21haWwuY29tIiwianRpIjoiY2UwYzk3ZjEtNGY4My00MTgwLTg0YjYtYjhmZTJjNzA3YzFkIiwiaXNzIjoiQUVNRVQiLCJpYXQiOjE1MjU4MTMyNTcsInVzZXJJZCI6ImNlMGM5N2YxLTRmODMtNDE4MC04NGI2LWI4ZmUyYzcwN2MxZCIsInJvbGUiOiIifQ.OwU32gwyQgddBVeREZ4InlPqiKIr9392asnhKw6ZSvo"
        return URL(string: "/opendata" + api + "/?api_key=" + api_key, relativeTo: baseURL)!
    }
    
    static var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        return dateFormatter
    }()
    
    static func observacionConvencionalTodas()-> Resource<AEMETResponseSuccess>{
        let url = urlApi("/api/observacion/convencional/todas")
        return Resource(url: url, AEMETResponseSuccess.self, dateFormatter: dateFormatter)
    }
    static func observacionConvencionalDatosEstacion(idema: String)-> Resource<AEMETResponseSuccess> {
        let url = urlApi("/api/observacion/convencional/datos/estacion/\(idema)")
        return Resource(url: url, AEMETResponseSuccess.self, dateFormatter: dateFormatter)
    }
    
    static func valoresClimatologicosInventarioEstacionesTodasEstaciones()-> Resource<AEMETResponseSuccess>{
        let url = urlApi("/api/valores/climatologicos/inventarioestaciones/todasestaciones")
        return Resource(url: url, AEMETResponseSuccess.self, dateFormatter: dateFormatter)
    }    
}


