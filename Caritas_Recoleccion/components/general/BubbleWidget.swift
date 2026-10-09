import SwiftUI

struct BubbleWidget: View {
    
    let backgroundColor : Color
    let textColor : Color
    let title : String
    let titleFontSize : CGFloat
    let value : String
    let valueFontSize : CGFloat
    let subtitle : String?
    let subtitleFontSize : CGFloat
    let textAlignment : HorizontalAlignment?
    let widgetAlignment : Alignment?
    
    init(backgroundColor: Color = ColorConstants.lightGray,
         textColor : Color = Color.black,
         title : String,
         titleFontSize : CGFloat = 12,
         value : String,
         valueFontSize : CGFloat = 48,
         subtitle : String? = nil,
         subtitleFontSize : CGFloat = 10,
         textAlignment : HorizontalAlignment = .leading,
         widgetAlignment : Alignment = .leading
    ) {
        self.backgroundColor = backgroundColor;
        self.textColor = textColor
        self.title = title;
        self.titleFontSize = titleFontSize
        self.value = value;
        self.valueFontSize = valueFontSize;
        self.subtitle = subtitle;
        self.subtitleFontSize = subtitleFontSize
        self.textAlignment = textAlignment;
        self.widgetAlignment = widgetAlignment;
    }
    
    var body: some View {
        VStack(alignment: textAlignment!) {
            Text(title)
                .font(.system(size: titleFontSize))
                .bold()

            Text(value)
                .font(.system(size: valueFontSize))
                .bold()

            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.system(size: subtitleFontSize))
                    .bold()
            }
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: widgetAlignment!)
        .padding(15)
        .background(backgroundColor)
        .foregroundStyle(textColor)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    ZStack {
        ColorConstants.background
        BubbleWidget(
            backgroundColor: ColorConstants.lightMainColor,
            textColor: ColorConstants.mainColor,
            title: "ÚLTIMA ACTIVIDAD HACE:",
            value: "22",
            subtitle: "DÍAS"
        )
    }
}
