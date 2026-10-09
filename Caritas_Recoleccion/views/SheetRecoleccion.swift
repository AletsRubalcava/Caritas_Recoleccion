import SwiftUI

struct SheetRecoleccion<Content: View>: View {
    @ViewBuilder let content: Content
    @Environment(\.dismiss) private var dismiss

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

                    Text("MELANIE RIVERA")
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

                        Button("ACEPTAR") {
                            mostrarConfirmacion = true
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(ColorConstants.mainColor)
                        .bold()

                        Spacer()
                    }
                }
                .padding()
            }
            .navigationDestination(isPresented: $mostrarConfirmacion) {
                ConfirmarRecoleccion {
                    dismiss()
                }
            }
        }
    }
}


#Preview {
    SheetRecoleccion(content: {
        VStack{
            HStack{
                InfoField(title: "Monto Recibido", value: "$10,236")
                InfoField(title: "Forma Pago", value: "Efectivo")
            }
            HStack{
                InfoField(title: "Fecha", value: "05/0/26")
                InfoField(title: "Status", value: "Completado")

            }
        }.frame(height: 200)
        
    })
}
