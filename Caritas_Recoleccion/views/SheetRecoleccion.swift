import SwiftUI

struct SheetRecoleccion<Content: View>: View {
    let idRecoleccion: Int
    let idEstado: Int
    let nombreDonante: String
    @ViewBuilder let content: Content
    @Environment(\.dismiss) private var dismiss
    @State private var guardando = false
    @State private var showError = false

    @State private var mostrarConfirmacion = false

    var body: some View {
        NavigationStack {
            ZStack {
                ColorConstants.background
                    .ignoresSafeArea()

                VStack(alignment: .leading) {
                    CheckmarkCircle()
                        .frame(width: 56)
                        .padding(.bottom, 10)
                        .padding(.top, 10)

                    Text("CONFIRMAR RECOLECCIÓN")
                        .font(.system(size: 22))
                        .bold()

                    Text(nombreDonante.uppercased())
                        .font(.system(size: 12))
                        .foregroundStyle(ColorConstants.lightGrayText)

                    Divider()
                        .padding(.bottom, 10)

                    content
                        .padding(.bottom, 10)

                    Text("Al confirmar, la promesa se marcará como completada y saldrá de tu lista de pendientes.")
                        .font(.system(size: 12))
                        .foregroundStyle(ColorConstants.lightGrayText)
                        .padding(.bottom, 10)

                    HStack(spacing: 20) {
                        Spacer()

                        Button("CANCELAR") {
                            dismiss()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(ColorConstants.lightGray)
                        .foregroundStyle(.black)
                        .bold()
                        .disabled(guardando)

                        Button {
                            Task { await confirmar() }
                        } label: {
                            if guardando {
                                ProgressView()
                            } else {
                                Text("ACEPTAR")
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(ColorConstants.mainColor)
                        .bold()
                        .disabled(guardando)

                        Spacer()
                    }
                }
                .padding()
            }
            .navigationDestination(isPresented: $mostrarConfirmacion) {
                ConfirmarRecoleccion(cerrarSheet: {
                    dismiss()
                },
                name: nombreDonante)
            }
            .alert("No se pudo registrar la recolección. Intenta de nuevo.", isPresented: $showError) {
                Button("OK") {}
            }
            .interactiveDismissDisabled(guardando)
        }
    }
    
    private func confirmar() async {
        guardando = true
        defer { guardando = false }

        do {
            try await RecoleccionService.updateEstadoRecoleccion(
                idRecoleccion: idRecoleccion,
                idEstado: idEstado
            )
            mostrarConfirmacion = true
        } catch {
            print("Error actualizando estado: \(error)")
            showError = true
        }
    }
}


#Preview {
    SheetRecoleccion(idRecoleccion: 1, idEstado: 2, nombreDonante: "Melanie Rivera") {
        
    }
}
