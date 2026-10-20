//
//  Login.swift
//  BOCETO_CARITAS
//
//  Created by Alumno on 21/09/26.
//

import Foundation


struct LoginRequest: Codable {
    let userName: String
    let password_hash: String
}

struct LoginResponse: Codable {
    let idUsuario: Int?
    let nombre: String?
    let idRol: Int?
    let error: String?
}
