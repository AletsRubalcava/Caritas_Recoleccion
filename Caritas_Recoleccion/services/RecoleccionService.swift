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
}
