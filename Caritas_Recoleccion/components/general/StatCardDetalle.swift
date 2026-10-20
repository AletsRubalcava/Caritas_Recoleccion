//
//  StatCardDetalle.swift
//  Caritas_Recoleccion
//
//  Created by Alumno on 09/10/26.
//

import SwiftUI

struct StatCardDetalle: View {
    let title: String
    let subtitulo: String
    let titleColor: Color
    let fontColor: Color
    let backColor: Color
    
    init(title: String, subtitulo: String, titleColor: Color = ColorConstants.mainColor, fontcolor: Color = ColorConstants.darkGray, backColor: Color = ColorConstants.lightGray) {
        self.title = title
        self.subtitulo = subtitulo
        self.titleColor = titleColor
        self.fontColor = fontcolor
        self.backColor = backColor
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(titleColor)

            Text(subtitulo)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(fontColor)
        }
        .padding(10)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(backColor)
        )
    }
}
