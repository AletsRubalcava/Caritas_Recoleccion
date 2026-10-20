//
//  RecoleccionesSemanales.swift
//  BOCETO_CARITAS
//
//  Created by Alumno on 10/09/26.
//

import Foundation

struct RecoleccionesSemanales: Identifiable, Codable {
    let id = UUID()
    let diaSemana: String
    let total: Int
    
    enum CodingKeys: String, CodingKey {
            case diaSemana = "DiaSemana"
            case total = "Total"
        }
}
