import SwiftUI

struct InfoRow: View {
    let icon : String
    let text : String
    let value: String
    
    var body: some View {
        Divider()
        HStack{
            Image(systemName: icon)
                .foregroundStyle(ColorConstants.mainColor)
            Text(text).font(.system(size: 13))
                .foregroundStyle(ColorConstants.darkGray)
            Spacer()
            Text(value)
                .font(.system(size: 14))
                .bold()
        }.padding(5)
    }
}

#Preview {
    InfoRow(icon: "calendar", text: "Fecha programada", value: "Lun 5 oct 2026")
}
