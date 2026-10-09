import SwiftUI

struct Header: View {
    @State private var logout = false
    var body: some View {
            VStack {
                HStack{
                    Image("Caritas-Photoroom")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 80)
                    Spacer()
                    // Generar un log out con este icono
                    /*Image(systemName: "person.circle")
                     .font(.system(size: 60))
                     .foregroundColor(.black.opacity(0.7))
                     */
                    
                    // Borrar despues de la presentacion
                    Button{
                        logout = true
                    }
                    label: {
                        Text("Log out")
                            .frame(maxWidth: 60)
                            .padding(.vertical, 5)
                            .font(.system(size: 16))
                            .fontWeight(.bold)
                        
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle(radius: 20))
                    .tint(Color(red:0, green: 152/255, blue: 174/255))
                }
                .padding(.horizontal, 40)
            }
            .background {
                Rectangle()
                    .fill(.white)
                    .shadow(radius: 5, y: 10)
            }
    }
}

#Preview {
    ZStack{
        Color.black
        Header()
    }
    
}
