import SwiftUI

struct CheckmarkCircle: View {
    var body: some View {
        ZStack {
            Circle()
                .foregroundStyle(ColorConstants.lowRisk.opacity(0.13))

            GeometryReader { geometry in
                Image(systemName: "checkmark")
                    .font(.system(size: geometry.size.width * 0.40))
                    .foregroundStyle(ColorConstants.lowRisk)
                    .bold()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

#Preview {
    CheckmarkCircle()
}
