//
//  Reprogramar.swift
//  Caritas_Recoleccion
//
//  Created by Alumno on 09/10/26.
//

import SwiftUI

struct Reprogramar: View {
    @State private var recoleccion = RecoleccionModel2(campana: "Campaña Hambre Cero", direccion: "Calle Falsa 123, Col. Centro", donante: "Oscar Ramirez Cruz", estado: "Completado", fecha: Date(), frecuencia: "Trimestal GMT", idRecolecion: 1, metodoPago: "Efectivo", montoARecolectar: 2500, tags: ["Alimentación", "Asistencia Social"], motivoRepro: "No se encontraba")
    var body: some View {
        ZStack{
            ColorConstants.background
            ScrollView{
                Header()
                VStack (spacing: 20){
                    HStack {
                        Spacer()
                        Text("REPROGRMAR")
                            .font(.system(size: 32))
                            .foregroundStyle(ColorConstants.mainColor)
                            .bold()
                            .multilineTextAlignment(.trailing)
                    }
                    PromesaBubble()
                    AlertBubble(mensaje: "La recoleccion se marcarpa como NO RECOLECTADA", textColor: ColorConstants.highRisk, backColor: ColorConstants.lightHighRisk, icon: "multiply")
                    MotivoSelection(motivoSeleccionado: $recoleccion.motivoRepro)
                    CalendarPicker(nuevaFecha: .constant(Date()), fechaActual: Date())
                    StatCardDetalle(title:"Fecha Seleccionada", subtitulo: "\(recoleccion.fecha)")
                    Button("Reprogramar Recoleccion"){
                    } .font(.system(size: 22))
                    .frame(maxWidth: .infinity)
                    .buttonStyle(.borderedProminent)
                    .tint(ColorConstants.mainColor)
                    .bold()

                }
                .padding(20)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    Reprogramar()
}
