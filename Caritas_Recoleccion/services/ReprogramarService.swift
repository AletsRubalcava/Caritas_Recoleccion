//
//  ReprogramarService.swift
//  Caritas_Recoleccion
//
//  Created by Alumno on 14/10/26.
//

import Foundation


private let urlBase = "https://equipo4.tc2007b.tec.mx:10207"

func getRecoleccionDetalle(id: Int) async throws -> RecoleccionReproModel {
    
    guard let url = URL(string:"\(urlBase)/recoleccion/\(id)") else {
        print("URL incorrecto")
        throw URLError(.badURL)
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let httpResponse = response as? HTTPURLResponse else {
        print("Respuesta no válida del servidor")
        throw URLError(.badServerResponse)
    }
    
    guard httpResponse.statusCode == 200 else {
        print("Código de error del API: \(httpResponse.statusCode)")
        throw URLError(.badServerResponse)
    }
    
    let jsonDecoder = JSONDecoder()
    
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
    
    jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
    
    let recoleccion = try jsonDecoder.decode(RecoleccionReproModel.self, from: data)
    
    return recoleccion
}

func getEstados(id: Int) async throws -> [EstadoRecoleccionModel] {
    guard let url = URL(string:"\(urlBase)/recolecccion\(id)") else {
        throw URLError(.badURL)
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw URLError(.badServerResponse)
    }
    
    return try JSONDecoder().decode([EstadoRecoleccionModel].self, from: data)
}

func ReprogramarRecoleccion(idRecoleccion: Int, peticion: ReprogramarRequestModel) async throws -> RecoleccionReproModel{
    guard let url = URL(string: "\(urlBase)/recoleccion/\(idRecoleccion)/reprogramar") else{
        throw URLError(.badURL)
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "PATCH"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    request.httpBody = try JSONEncoder().encode(peticion)
    
    let (data, response) = try await URLSession.shared.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse else {
        throw URLError(.badServerResponse)
    }
    
    guard httpResponse.statusCode == 200 else {
        let body = String(data: data, encoding: .utf8) ?? ""
        print("Codigo de error del API \(httpResponse.statusCode) - \(body)")
        throw URLError(.badServerResponse)
    }
    
    let decoder = JSONDecoder()
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
    decoder.dateDecodingStrategy = .formatted(dateFormatter)
    
    return try decoder.decode(RecoleccionReproModel.self, from: data)
}
