//
//  MontoSumRec.swift
//  BOCETO_CARITAS
//
//  Created by Alumno on 10/09/26.
//

import Foundation

struct MontoSumRec : Identifiable, Codable {
    let id = UUID()
    let monto: Int
    enum CodingKeys: String, CodingKey {
            case monto = "montoSemanal"
        }
}
