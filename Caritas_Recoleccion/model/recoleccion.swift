import Foundation

struct RecoleccionModel : Codable{
    let campana : String
    let direccion : String
    let donante : String
    let estado : String
    let fecha : String
    let frecuencia : String
    let idRecoleccion : Int
    let metodoPago : String
    let montoARecolectar : Float
    let tags : [String]
}
