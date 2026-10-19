import Foundation

class RecoleccionService {
    
    static let urlBase = "https://equipo4.tc2007b.tec.mx:10207"
    
    static func getRecoleccion(id : Int) async throws -> RecoleccionModel{
        
        guard let url = URL(string:"\(urlBase)/collection?id=\(id)") else{
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
        let recoleccion = try jsonDecoder.decode(RecoleccionModel.self, from: data)
        
        return recoleccion
    }
    
    static func getEstadosRecoleccion() async throws -> [EstadoRecoleccionModel] {
        
        guard let url = URL(string: "\(urlBase)/collection/states") else {
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
        let estados = try jsonDecoder.decode([EstadoRecoleccionModel].self, from: data)
        
        return estados
    }
    
    static func updateEstadoRecoleccion(idRecoleccion: Int, idEstado: Int) async throws {
        
        guard let url = URL(string: "\(urlBase)/collection/state") else {
            print("URL incorrecto")
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(
            UpdateEstadoRequest(idRecoleccion: idRecoleccion, idEstado: idEstado)
        )
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("Respuesta no válida del servidor")
            throw URLError(.badServerResponse)
        }
        
        switch httpResponse.statusCode {
        case 200:
            return
        case 400:
            print("Estado inválido o datos incompletos")
            throw URLError(.badServerResponse)
        case 404:
            print("Recolección no encontrada")
            throw URLError(.resourceUnavailable)
        default:
            print("Código de error del API: \(httpResponse.statusCode)")
            throw URLError(.badServerResponse)
        }
    }
}
