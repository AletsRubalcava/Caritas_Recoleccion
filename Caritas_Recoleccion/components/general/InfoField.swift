import SwiftUI

struct InfoField: View {
    
    var title: String
    var value: String
    var icon: String?
    
    var body: some View {
        HStack {
            
            if let icon = icon {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(.white)
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundStyle(ColorConstants.mainColor)
                }
            }
            
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .font(.system(size: 18))
                    .bold()
                    .foregroundStyle(ColorConstants.mainColor)
                
                Text("\(value)")
                    .font(.system(size: 16))
                    .bold()
            }
            
            Spacer()
        }
        .padding(8)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ColorConstants.lightGray)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    InfoField(
        title: "Casa",
        value: "81 8485 4792",
        icon: "house"
    )
    .frame(width: 400)
}
