import SwiftUI

struct TextBubble: View {
    
    let title: String
    let icon: String?
    let fontSize: CGFloat
    let background: Color
    let fontColor: Color
    let expanded: Bool
    
    init(
        title: String,
        icon: String? = nil,
        fontSize: CGFloat = 12,
        background: Color = ColorConstants.darkGray.opacity(0.1),
        fontColor: Color = ColorConstants.darkGray,
        expanded: Bool = false
    ) {
        self.title = title
        self.icon = icon
        self.fontSize = fontSize
        self.background = background
        self.fontColor = fontColor
        self.expanded = expanded
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if expanded {
                    Spacer()
                }
                
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: fontSize))
                        .foregroundStyle(fontColor)
                }
                
                Text(title)
                    .font(.system(size: fontSize))
                    .foregroundStyle(fontColor)
                    .bold()
                
                if expanded {
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(background)
        .foregroundStyle(fontColor)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .frame(maxHeight: expanded ? .infinity : nil)
    }
}

#Preview {
    ZStack {
        ColorConstants.background
        TextBubble(
            title: "Estado"
        )
    }
}
