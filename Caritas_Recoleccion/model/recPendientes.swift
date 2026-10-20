//
//  RecPendientes.swift
//  BOCETO_CARITAS
//
//  Created by Alumno on 10/09/26.
//

import Foundation

struct RecPendientes : Identifiable, Codable {
    let id = UUID()
    let numRec: Int
    
    enum CodingKeys: String, CodingKey {
            case numRec = "recoleccionesSemanal"
        }
}
