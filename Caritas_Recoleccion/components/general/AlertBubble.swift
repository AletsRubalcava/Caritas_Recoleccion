//
//  AlertBubble.swift
//  Caritas_Recoleccion
//
//  Created by Alumno on 09/10/26.
//

import SwiftUI

struct AlertBubble: View {
    let mensaje: String
    let textColor: Color
    let backColor: Color
    let icon: String
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Image(systemName: icon)
                .bold()
            Text(mensaje)
                .font(.system(size: 18, weight: .bold))
                .padding(10)
        }
        .padding(7)
        .background(backColor)
        .foregroundStyle(textColor)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    AlertBubble(mensaje: "La recoleccion se marcarpa como NO RECOLECTADA", textColor: ColorConstants.highRisk, backColor: ColorConstants.lightHighRisk, icon: "multiply")
}
