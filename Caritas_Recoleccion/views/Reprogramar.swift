//
//  Reprogramar.swift
//  Caritas_Recoleccion
//
//  Created by Alumno on 09/10/26.
//

import SwiftUI

struct Reprogramar: View {
    let idRecoleccion: Int = 1
    @State private var recoleccionRepro: RecoleccionReproModel?
    
    @State private var motivoSeleccionado: String = "No se encontraba"
    @State private var nuevaFechaSeleccionada: Date = Date()
    
    @State private var isLoading: Bool = true
    @State private var errorMessage: String? = nil
    
    private func cargarDatos() async{
        do{
            let datos = try await ReprogramarService.getRecoleccionDetalle(id: idRecoleccion)
            await MainActor.run {
                self.recoleccionRepro = datos
                self.nuevaFechaSeleccionada = Calendar.current.date(byAdding: .day, value: 1, to: datos.fechaActual) ?? Date()
                self.isLoading = false
            }
        } catch{
            print("Error: \(error)")
            await MainActor.run{
                self.errorMessage = "Error al cargar los datos"
                self.isLoading = false
            }
        }
    }
    
    private var dateFormatterDisplay: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }
    
    var body: some View {
        ZStack{
            ColorConstants.background
            if isLoading {
                ProgressView("Cargando detalles...")
                    .tint(ColorConstants.mainColor)
            } else if let recoleccion = recoleccionRepro {
                ScrollView{
                    Header()
                    VStack (spacing: 20){
                        HStack {
                            Spacer()
                            Text("REPROGRAMAR")
                                .font(.system(size: 32))
                                .foregroundStyle(ColorConstants.mainColor)
                                .bold()
                                .multilineTextAlignment(.trailing)
                        }
                        PromesaBubble()
                        AlertBubble(mensaje: "La recoleccion se marcara como NO RECOLECTADA", textColor: ColorConstants.highRisk, backColor: ColorConstants.lightHighRisk, icon: "multiply")
                        MotivoSelection(motivoSeleccionado: $motivoSeleccionado)
                        CalendarPicker(nuevaFecha: $nuevaFechaSeleccionada, fechaActual: recoleccion.fechaActual)
                        StatCardDetalle(
                            title:"FECHA SELECCIONADA",
                            subtitulo: dateFormatterDisplay.string(from: nuevaFechaSeleccionada))
                        Button("REPROGRAMAR RECOLECCION"){
                        } .font(.system(size: 22))
                            .frame(maxWidth: .infinity)
                            .buttonStyle(.borderedProminent)
                            .tint(ColorConstants.mainColor)
                            .bold()
                        
                    }
                    .padding(20)
                }
            } else if let error = errorMessage{
                VStack(spacing:16){
                    Text("ERROR")
                }
            }
        }
        .ignoresSafeArea()
        .task{
            await cargarDatos()
        }
    }
}

#Preview {
    Reprogramar()
}
