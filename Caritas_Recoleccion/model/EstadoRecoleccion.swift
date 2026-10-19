import Foundation

struct EstadoRecoleccionModel: Codable, Identifiable {
    let idEstado: Int
    let nombre: String
    
    var id: Int { idEstado }
}

struct UpdateEstadoRequest: Codable {
    let idRecoleccion: Int
    let idEstado: Int
}
