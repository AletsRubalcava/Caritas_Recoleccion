import Foundation

struct RecoleccionReproModel: Codable{
    let nombre : String
    let apellidoPaterno: String
    let apellidoMaterno: String
    let direccion: String
    let estadoNombre: String
    let fechaActual: Date
    let idDonante: Int
    let idEstado: Int
    let idPromesa: Int
    let idRecoleccion: Int
    let monto: Double
    
    var motivoRepro: String?
    
    var nombreCompleto: String{
        return "\(nombre) \(apellidoPaterno) \(apellidoMaterno)"
    }
}

struct EstadoRecoleccionModel: Codable, Identifiable{
    var id: Int {idEstado}
    let idEstado: Int
    let nombre: String
}

struct ReprogramarRequestModel: Codable{
    let nuevaFecha: String
    let motivo: Double
    let idEstado: Int
}
