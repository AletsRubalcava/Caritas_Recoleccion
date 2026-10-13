import Foundation

struct RecoleccionModel2 : Codable{
    let campana : String
    let direccion : String
    let donante : String
    let estado : String
    let fecha : Date
    let frecuencia : String
    let idRecolecion : Int
    let metodoPago : String
    let montoARecolectar : Float
    let tags : [String]
    var motivoRepro: String
}
