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

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(ColorConstants.mainColor)

            Text(subtitulo)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(ColorConstants.darkGray)
        }
        .padding(10)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(ColorConstants.lightGray)
        )
    }
}
