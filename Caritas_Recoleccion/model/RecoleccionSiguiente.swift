//
//  RecoleccionSiguiente.swift
//  BOCETO_CARITAS
//
//  Created by Alumno on 11/09/26.
//

import Foundation

struct RecoleccionSiguiente: Identifiable, Hashable, Codable {
    var id: Int { idRecoleccion }    
    let idRecoleccion : Int
    let apellidoPaterno: String
    let fecha: String
    let monto: Int
    let nombre: String
}
