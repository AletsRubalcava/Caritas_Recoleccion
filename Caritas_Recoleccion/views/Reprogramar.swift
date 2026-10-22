import SwiftUI

struct Reprogramar: View {
    @Environment(\.dismiss) private var dismiss
    let idRecoleccion: Int

    @State private var recoleccionRepro: RecoleccionReproModel?
    @State private var motivoSeleccionado: String = "No se encontraba"
    @State private var nuevaFechaSeleccionada: Date = Date()

    @State private var isLoading = true
    @State private var errorMessage: String?

    @State private var estados: [EstadoRecoleccionModel] = []
    private let idEstadoCompletada = 2

    @State private var isSubmitting = false
    @State private var mostrarExito = false
    @State private var errorEnvio: String?

    // MARK: - Fechas

    private var fechaSeleccionadaTexto: String {
        formatDate(apiString(fromLocalDay: nuevaFechaSeleccionada))
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
            let texto = formatDate(apiString(fromGMT: recoleccion.fechaActual))
            return "La nueva fecha debe ser posterior a la recolección actual (\(texto))."
        }
        return nil
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            ColorConstants.background
                .ignoresSafeArea()

            if isLoading {
                ProgressView("Cargando detalles...")
                    .tint(ColorConstants.mainColor)
            } else if let recoleccion = recoleccionRepro {
                contenido(recoleccion)
            } else if errorMessage != nil {
                VStack(spacing: 16) {
                    Text("Error al cargar los datos")
                }
            }
        }
        .task { await cargar() }
        .alert("Recolección reprogramada", isPresented: $mostrarExito) {
            Button("OK") { dismiss() }
        } message: {
            Text("La nueva fecha es \(fechaSeleccionadaTexto).")
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

    @ViewBuilder
    private func contenido(_ recoleccion: RecoleccionReproModel) -> some View {
        let errorDeFecha = errorFecha(para: recoleccion)
        let completada = recoleccion.idEstado == idEstadoCompletada
        let nombreEstado = estados.first(where: { $0.idEstado == idEstadoCompletada })?.nombre ?? "Completada"

        ScrollView {
            VStack(spacing: 20) {
                HStack {
                    Spacer()
                    Text("REPROGRAMAR")
                        .font(.system(size: 32))
                        .foregroundStyle(ColorConstants.mainColor)
                        .bold()
                        .multilineTextAlignment(.trailing)
                }

                PromesaBubble(nombre: recoleccion.nombre,
                              direccion: recoleccion.direccion,
                              monto: recoleccion.monto)

                AlertBubble(mensaje: "La recoleccion se marcara como NO RECOLECTADA",
                            textColor: ColorConstants.highRisk,
                            backColor: ColorConstants.lightHighRisk,
                            icon: "multiply")

                MotivoSelection(motivoSeleccionado: $motivoSeleccionado)
                    .disabled(completada)
                    .opacity(completada ? 0.5 : 1)

                CalendarPicker(nuevaFecha: $nuevaFechaSeleccionada,
                               fechaActual: diaLocal(deGMT: recoleccion.fechaActual))
                    .disabled(completada)
                    .opacity(completada ? 0.5 : 1)

                StatCardDetalle(title: "FECHA SELECCIONADA",
                                subtitulo: fechaSeleccionadaTexto)

                if completada {
                    alerta("Estado actual: \(nombreEstado). No se puede reprogramar una entrega que ya fue completada.")
                } else if let errorDeFecha {
                    alerta(errorDeFecha)
                }

                Button {
                    Task { await reprogramar() }
                } label: {
                    if isSubmitting {
                        ProgressView().tint(.white)
                    } else {
                        Text("REPROGRAMAR RECOLECCION")
                    }
                }
                .font(.system(size: 22))
                .frame(maxWidth: .infinity)
                .buttonStyle(.borderedProminent)
                .tint(ColorConstants.mainColor)
                .bold()
                .disabled(isSubmitting || completada || errorDeFecha != nil)
            }
            .padding(20)
        }
    }

    private func alerta(_ mensaje: String) -> some View {
        AlertBubble(mensaje: mensaje,
                    textColor: ColorConstants.highRisk,
                    backColor: ColorConstants.lightHighRisk,
                    icon: "exclamationmark.triangle")
    }

    // MARK: - Red

    private func cargar() async {
        do {
            recoleccionRepro = try await getRecoleccionDetalle(id: idRecoleccion)
        } catch {
            errorMessage = error.localizedDescription
            print("Error en task: \(error)")
        }
        isLoading = false
    }

    private func reprogramar() async {
        guard let recoleccion = recoleccionRepro,
              errorFecha(para: recoleccion) == nil else { return }

        isSubmitting = true
        defer { isSubmitting = false }

        let peticion = ReprogramarRequestModel(
            nuevaFecha: apiDateOnly(fromLocalDay: nuevaFechaSeleccionada),
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
    Reprogramar(idRecoleccion: 1)
}
