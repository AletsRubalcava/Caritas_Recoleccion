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

struct ReprogramarRequestModel: Codable{
    let nuevaFecha: String
    let motivo: String
}
