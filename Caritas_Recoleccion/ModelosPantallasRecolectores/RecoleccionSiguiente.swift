//
//  RecoleccionSiguiente.swift
//  BOCETO_CARITAS
//
//  Created by Alumno on 11/09/26.
//

import Foundation

struct RecoleccionSiguiente: Identifiable, Hashable, Codable {
    let id = UUID()
    let apellidoPaterno: String
    let fecha: String
    let monto: Int
    let nombre: String
}
