import SwiftUI

struct InfoBox<Content: View>: View {
    
    var title: String
    var titleSize: CGFloat = 24
    var icon: String
    
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(ColorConstants.mainColor)
                
                Text(title)
                    .font(.system(size: titleSize))
                    .bold()
                    .padding(.vertical, 20)
            }
            .padding(.horizontal, 22)
            
            Divider()
            
            content
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}


#Preview {
    ZStack {
        Color(.gray)
        VStack {
            InfoBox(title: "CANALES DE CONTACTO", icon: "phone.fill", content: {
                HStack {
                    VStack {
                        InfoField(title: "CASA", value: "81 84845 4792", icon: "home")
                        InfoField(title: "OFICINA", value: "81 5739 5693", icon: "home")
                    }
                    VStack {
                        InfoField(title: "MÓVIL", value: "81 5728 2767", icon: "home")
                        InfoField(title: "TEMPORAL", value: "81 1067 2864", icon: "home")
                    }
                }.padding()
            })
        }
    }
}
