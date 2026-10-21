//
//  LoginService.swift
//  BOCETO_CARITAS
//
//  Created by Alumno on 21/09/26.
//

import Foundation

private let urlBase = "https://equipo4.tc2007b.tec.mx:10207/"

func verificarLogin(_ newLogin: LoginRequest) async throws -> LoginResponse{
    
  guard let url = URL(string: "\(urlBase)login") else{
      print("URL incorrecto")
      throw URLError(.badURL)
  }
    
  var requestX = URLRequest(url: url)
    requestX.httpMethod = "POST"
    requestX.setValue("application/json", forHTTPHeaderField: "Content-Type")
    requestX.httpBody = try JSONEncoder().encode(newLogin)
  
  let (data, response) = try await URLSession.shared.data(for: requestX)
  
  guard let httpResponse = response as? HTTPURLResponse else {
      print("Respuesta no válida del servidor")
      throw URLError(.badServerResponse)
  }
  
    guard httpResponse.statusCode == 200 || httpResponse.statusCode == 201 || httpResponse.statusCode == 401 else {
      print("Código de error del API: \(httpResponse.statusCode)")
      throw URLError(.badServerResponse)
  }
    
    let verificado: LoginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)

    if let error = verificado.error {
        print("Error en el login: \(error)")
    } else if let token = verificado.token {
        Sesion.shared.token = token.trimmingCharacters(in: .whitespacesAndNewlines)
        print("Token guardado")
    }

    return verificado
}
