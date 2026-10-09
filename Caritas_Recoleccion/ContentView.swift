import SwiftUI

struct ContentView: View {
    @State private var showSheet = false
    
    var body: some View {
        ZStack {
            ColorConstants.background
            
            VStack {
                Button("Registrar Recolección"){
                    showSheet = true
                }.buttonStyle(.borderedProminent)
            }
        }.ignoresSafeArea()
            .sheet(isPresented: $showSheet) {
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
                    }.frame(height: 150)
                }
                ).presentationDetents([.medium])
        }
    }
}

#Preview {
    ContentView()
}
