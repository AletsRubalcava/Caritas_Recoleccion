
import SwiftUI

struct PagoParcial: View {
//    @State var montoRecibido: String = "0.0"
    let idRecoleccion : Int
//
   var body: some View {
//        ZStack{
//            ColorConstants.background
//            ScrollView{
//                Header()
//                VStack (spacing: 20){
//                    HStack {
//                        Spacer()
//                        Text("PAGO PARCIAL")
//                            .font(.system(size: 32))
//                            .foregroundStyle(ColorConstants.mainColor)
//                            .bold()
//                            .multilineTextAlignment(.trailing)
//                    }
//                    PromesaBubble(nombre "Ahhh", direccion: "BBBB", monto: 10)
//                    AlertBubble(mensaje: "La recoleccion se marcara como PARCIALMENTE RECOLECTADA", textColor: ColorConstants.midRisk, backColor: ColorConstants.lightMidRisk, icon: "circle.righthalf.filled")
//                    TextBox(montoRecibido: $montoRecibido, montoTotal: Double(recoleccion.montoARecolectar))
//                    CalendarPicker(nuevaFecha: .constant(Date()), fechaActual: Date())
//                    StatCardDetalle(title:"FECHA SELECCIONADA", subtitulo: "\(recoleccion.fecha)")
//                    Button("REGISTRAR PAGO PARCIAL"){
//                    } .font(.system(size: 22))
//                    .frame(maxWidth: .infinity)
//                    .buttonStyle(.borderedProminent)
//                    .tint(ColorConstants.mainColor)
//                    .bold()
//
//                }
//                .padding(20)
//            }
//        }
//        .ignoresSafeArea()
    }
}
//
#Preview {
    PagoParcial(idRecoleccion: 1)
}
