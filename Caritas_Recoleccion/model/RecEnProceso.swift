//
//  RecEnProceso.swift
//  BOCETO_CARITAS
//
//  Created by Alumno on 10/09/26.
//

import Foundation

struct RecEnProceso : Identifiable, Codable {
    let id = UUID()
    let numRecHoy: Int
    enum CodingKeys: String, CodingKey {
            case numRecHoy = "recoleccionesHoy"
        }
}
