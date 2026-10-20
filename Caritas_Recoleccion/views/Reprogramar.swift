//
//  Reprogramar.swift
//  Caritas_Recoleccion
//
//  Created by Alumno on 09/10/26.
//

import SwiftUI

struct Reprogramar: View {
    @Environment(\.dismiss) private var dismiss
    let idRecoleccion: Int = 1
    @State private var recoleccionRepro: RecoleccionReproModel?
    
    @State private var motivoSeleccionado: String = "No se encontraba"
    @State private var nuevaFechaSeleccionada: Date = Date()
    
    @State private var isLoading: Bool = true
    @State private var errorMessage: String? = nil
    
    @State private var isSubmitting: Bool = false
    @State private var mostrarExito: Bool = false
    @State private var errorEnvio: String? = nil
    
    private var dateFormatterAPI: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    private var dateFormatterDisplay: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }
    
    private func diaLocal(deGMT fecha: Date) -> Date {
        var gmt = Calendar(identifier: .gregorian)
        gmt.timeZone = TimeZone(identifier: "GMT")!
        let comps = gmt.dateComponents([.year, .month, .day], from: fecha)
        return Calendar.current.date(from: comps) ?? fecha
    }
    
    private func errorFecha(para recoleccion: RecoleccionReproModel) -> String? {
        let cal = Calendar.current
        let hoy = cal.startOfDay(for: Date())
        let nueva = cal.startOfDay(for: nuevaFechaSeleccionada)
        let actual = diaLocal(deGMT: recoleccion.fechaActual)
        
        if nueva < hoy {
            return "No puedes elegir una fecha pasada."
        }
        if nueva <= actual {
            return "La nueva fecha debe ser posterior a la recolección actual (\(dateFormatterDisplay.string(from: actual)))."
        }
        return nil
    }
    
    var body: some View {
        ZStack{
            ColorConstants.background
            if isLoading {
                ProgressView("Cargando detalles...")
                    .tint(ColorConstants.mainColor)
            } else if let recoleccion = recoleccionRepro {
                let errorDeFecha = errorFecha(para: recoleccion)
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
                        PromesaBubble(nombre: recoleccion.nombre, direccion: recoleccion.direccion, monto: recoleccion.monto)
                        AlertBubble(mensaje: "La recoleccion se marcara como NO RECOLECTADA", textColor: ColorConstants.highRisk, backColor: ColorConstants.lightHighRisk, icon: "multiply")
                        MotivoSelection(motivoSeleccionado: $motivoSeleccionado)
                        CalendarPicker(nuevaFecha: $nuevaFechaSeleccionada, fechaActual: recoleccion.fechaActual)
                        StatCardDetalle(
                            title:"FECHA SELECCIONADA",
                            subtitulo: dateFormatterDisplay.string(from: nuevaFechaSeleccionada))
                        if let errorDeFecha {
                            AlertBubble(
                                mensaje: errorDeFecha,
                                textColor: ColorConstants.highRisk,
                                backColor: ColorConstants.lightHighRisk,
                                icon: "exclamationmark.triangle")
                        }
                        Button {
                            Task { await reprogramar() }
                        } label: {
                            if isSubmitting {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("REPROGRAMAR RECOLECCION")
                            }
                        } .font(.system(size: 22))
                            .frame(maxWidth: .infinity)
                            .buttonStyle(.borderedProminent)
                            .tint(ColorConstants.mainColor)
                            .bold()
                            .disabled(isSubmitting || errorDeFecha != nil)
                        
                    }
                    .padding(20)
                }
            } else if let error = errorMessage{
                VStack(spacing:16){
                    Text("Error al cargar los datos")
                }
            }
        }
        .ignoresSafeArea()
        .task {
            do {
                recoleccionRepro = try await getRecoleccionDetalle(id: idRecoleccion)
                isLoading = false
            } catch {
                errorMessage = error.localizedDescription
                isLoading = false
                print("Error en task: \(error)")
            }
        }
        .alert("Recolección reprogramada", isPresented: $mostrarExito) {
            Button("OK") { dismiss() }
        } message: {
            Text("La nueva fecha es \(dateFormatterDisplay.string(from: nuevaFechaSeleccionada)).")
        }
        .alert("No se pudo reprogramar", isPresented: Binding(
            get: { errorEnvio != nil },
            set: { if !$0 { errorEnvio = nil } }
        )) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorEnvio ?? "")
        }
    }
    
    private func reprogramar() async {
        guard let recoleccion = recoleccionRepro,
              errorFecha(para: recoleccion) == nil else { return }
        
        isSubmitting = true
        defer { isSubmitting = false }
        
        let peticion = ReprogramarRequestModel(
            nuevaFecha: dateFormatterAPI.string(from: nuevaFechaSeleccionada),
            motivo: motivoSeleccionado)
        
        do {
            recoleccionRepro = try await ReprogramarRecoleccion(
                idRecoleccion: idRecoleccion,
                peticion: peticion)
            mostrarExito = true
        } catch {
            errorEnvio = "Revisa tu conexión e intenta de nuevo."
            print("Error al reprogramar: \(error)")
        }
    }
}

#Preview {
    Reprogramar()
}
