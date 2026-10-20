import SwiftUI

struct ConfirmarRecoleccion: View {
    let cerrarSheet: () -> Void
    @State public var name : String

    var body: some View {
        ZStack {
            ColorConstants.background

            VStack {
                CheckmarkCircle()
                    .frame(width: 120, height: 120)
                    .padding(.bottom, 10)

                Text("¡RECOLECCIÓN CONFIRMADA!")
                    .font(.system(size: 22))
                    .foregroundStyle(ColorConstants.lowRisk)
                    .bold()
                    .padding(.bottom, 10)

                Text("La promesa de \(name) se marcó como completada.")
                    .font(.system(size: 14))
                    .foregroundStyle(ColorConstants.lightGrayText)
                    .multilineTextAlignment(.center)
                    .bold()
                    .padding(.bottom, 20)

                Button("Aceptar") {
                    cerrarSheet()
                }
                .buttonStyle(.borderedProminent)
                .tint(ColorConstants.mainColor)
                .bold()
            }
            .padding()
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
    }
}



#Preview {
    ConfirmarRecoleccion(cerrarSheet: {}, name: "Melaine Rivera")
}
