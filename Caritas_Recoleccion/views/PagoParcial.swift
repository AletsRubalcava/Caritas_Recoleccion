import SwiftUI

struct PagoParcial: View {
    @Environment(\.dismiss) private var dismiss
    let idRecoleccion: Int
    
    @State private var montoRecibido: String = ""
    @State private var nuevaFechaSeleccionada: Date = Date()
    
    @State private var recoleccion: RecoleccionReproModel?
    @State private var isLoading: Bool = true
    @State private var errorMessage: String? = nil
    
    @State private var isSubmitting: Bool = false
    @State private var mostrarExito: Bool = false
    @State private var errorEnvio: String? = nil
    
    private var dateFormatterDisplay: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }
    
    private let idEstadoCompletada = 2
    
    private func diaLocal(deGMT fecha: Date) -> Date {
        var gmt = Calendar(identifier: .gregorian)
        gmt.timeZone = TimeZone(identifier: "GMT")!
        let comps = gmt.dateComponents([.year, .month, .day], from: fecha)
        return Calendar.current.date(from: comps) ?? fecha
    }
    
    private func errorMonto(para recoleccion: RecoleccionReproModel) -> String? {
        guard !montoRecibido.isEmpty else { return nil }
        guard let monto = Double(montoRecibido), monto > 0 else {
            return "Ingresa un monto válido mayor a 0."
        }
        if monto >= recoleccion.monto {
            return "El monto recibido debe ser menor a la promesa total."
        }
        return nil
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
        ZStack {
            ColorConstants.background
            
            if isLoading {
                ProgressView("Cargando detalles...")
                    .tint(ColorConstants.mainColor)
            } else if let recoleccion = recoleccion {
                let completada = recoleccion.idEstado == idEstadoCompletada
                let errorDeMonto = errorMonto(para: recoleccion)
                let errorDeFecha = errorFecha(para: recoleccion)
                ScrollView {
                    VStack(spacing: 20) {
                        HStack {
                            Spacer()
                            Text("PAGO PARCIAL")
                                .font(.system(size: 32))
                                .foregroundStyle(ColorConstants.mainColor)
                                .bold()
                                .multilineTextAlignment(.trailing)
                        }
                        
                        PromesaBubble(nombre: recoleccion.nombre, direccion: recoleccion.direccion, monto: recoleccion.monto)
                        AlertBubble(mensaje: "La recoleccion se marcara como PARCIALMENTE RECOLECTADA", textColor: ColorConstants.midRisk, backColor: ColorConstants.lightMidRisk, icon: "circle.righthalf.filled")
                        TextBox(montoRecibido: $montoRecibido, montoTotal: recoleccion.monto)
                            .disabled(completada)
                            .opacity(completada ? 0.5 : 1)
                        CalendarPicker(nuevaFecha: $nuevaFechaSeleccionada, fechaActual: recoleccion.fechaActual)
                            .disabled(completada)
                            .opacity(completada ? 0.5 : 1)
                        StatCardDetalle(title: "FECHA SELECCIONADA", subtitulo: dateFormatterDisplay.string(from: nuevaFechaSeleccionada))
                        
                        if completada {
                            AlertBubble(mensaje: "Esta recolección ya está completada; no se puede registrar un pago parcial.", textColor: ColorConstants.highRisk, backColor: ColorConstants.lightHighRisk, icon: "exclamationmark.triangle")
                        } else if let errorDeMonto {
                            AlertBubble(mensaje: errorDeMonto, textColor: ColorConstants.highRisk, backColor: ColorConstants.lightHighRisk, icon: "exclamationmark.triangle")
                        } else if let errorDeFecha {
                            AlertBubble(mensaje: errorDeFecha, textColor: ColorConstants.highRisk, backColor: ColorConstants.lightHighRisk, icon: "exclamationmark.triangle")
                        }
                        
                        Button {
                            Task { await guardarPagoParcial() }
                        } label: {
                            if isSubmitting {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("REGISTRAR PAGO PARCIAL")
                            }
                        }
                        .font(.system(size: 22))
                        .frame(maxWidth: .infinity)
                        .buttonStyle(.borderedProminent)
                        .tint(ColorConstants.mainColor)
                        .bold()
                        .disabled(isSubmitting || completada || errorDeMonto != nil || errorDeFecha != nil || montoRecibido.isEmpty)
                    }
                    .padding(20)
                }
            } else if let error = errorMessage {
                VStack(spacing: 16) {
                    Text("Error al cargar los datos")
                    Text(error).font(.caption).foregroundColor(.red)
                }
            }
        }
        .task {
            do {
                recoleccion = try await getRecoleccionDetalle(id: idRecoleccion)
                print(recoleccion)
                isLoading = false
            } catch {
                errorMessage = error.localizedDescription
                isLoading = false
                print("Error en task: \(error)")
            }
        }
        .alert("Pago parcial registrado", isPresented: $mostrarExito) {
            Button("OK") { dismiss() }
        } message: {
            Text("Se registró el pago y la nueva fecha de recolección.")
        }
        .alert("Error al registrar", isPresented: Binding(
            get: { errorEnvio != nil },
            set: { if !$0 { errorEnvio = nil } }
        )) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorEnvio ?? "")
        }
    }
    
    private func guardarPagoParcial() async {
        isSubmitting = true
        defer { isSubmitting = false }
        
        guard let recoleccion = recoleccion,
              recoleccion.idEstado != idEstadoCompletada,
              errorMonto(para: recoleccion) == nil,
              errorFecha(para: recoleccion) == nil,
              let monto = Double(montoRecibido) else { return }
        
        let backendDateFormatter = DateFormatter()
        backendDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        backendDateFormatter.dateFormat = "yyyy-MM-dd"
        let fechaString = backendDateFormatter.string(from: nuevaFechaSeleccionada)
        
        let peticion = PagoParcialRequestModel(
            montoRecibido: monto,
            motivo: "Pago parcial registrado",
            nuevaFecha: fechaString
        )
        
        do {
            _ = try await registrarPagoParcial(idRecoleccion: idRecoleccion, peticion: peticion)
            mostrarExito = true
        } catch {
            errorEnvio = (error as? LocalizedError)?.errorDescription ?? "Revisa tu conexión e intenta de nuevo."
            print("Error al registrar pago parcial: \(error)")
        }
    }
}

#Preview {
    PagoParcial(idRecoleccion: 1)
}
