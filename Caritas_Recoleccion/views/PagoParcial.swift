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
    
    var body: some View {
        ZStack {
            ColorConstants.background
            
            if isLoading {
                ProgressView("Cargando detalles...")
                    .tint(ColorConstants.mainColor)
            } else if let recoleccion = recoleccion {
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
                        CalendarPicker(nuevaFecha: $nuevaFechaSeleccionada, fechaActual: recoleccion.fechaActual)
                        StatCardDetalle(title: "FECHA SELECCIONADA", subtitulo: dateFormatterDisplay.string(from: nuevaFechaSeleccionada))
                        
                        Button {
                            Task { await registrarPagoParcial() }
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
                        .disabled(isSubmitting || montoRecibido.isEmpty)
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
        .ignoresSafeArea()
        .task {
            do {
                recoleccion = try await getRecoleccionDetalle(id: idRecoleccion)
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
    
    private func registrarPagoParcial() async {
        isSubmitting = true
        defer { isSubmitting = false }
        
        do {
            // Pendiente
            
            mostrarExito = true
        } catch {
            errorEnvio = "Revisa tu conexión e intenta de nuevo."
            print("Error al registrar pago parcial: \(error)")
        }
    }
}

#Preview {
    PagoParcial(idRecoleccion: 1)
}
