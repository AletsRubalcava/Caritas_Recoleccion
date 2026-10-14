//
//  TextField.swift
//  Caritas_Recoleccion
//
//  Created by Alumno on 12/10/26.
//

import SwiftUI

struct TextBox: View {
    @Binding var montoRecibido: String
    let montoTotal: Double
    
    var restante: Double {
        let ingresado = Double(montoRecibido) ?? 0
        return max(0, montoTotal - ingresado)
    }
    
    var body: some View {
        VStack(alignment: .leading){
            Text("MONTO DEL PAGO PARCIAL")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(ColorConstants.darkGray)
            
            VStack(alignment: .leading){
                Text("MONTO RECIBIDO:")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(ColorConstants.mainColor)
                HStack{
                    Text("$")
                        .font(Font.system(size: 30, weight: .bold, design: .rounded))
                    TextField("Ingresa un monto", text: $montoRecibido, onEditingChanged: { _ in })
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .keyboardType(.numberPad)
                        .tint(ColorConstants.mainColor)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(ColorConstants.darkGray, lineWidth: 1)
                )
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(ColorConstants.mainColor)
            )
            
            HStack{
                StatCardDetalle(title: "MONTO TOTAL", subtitulo: String(montoTotal))
                StatCardDetalle(title: "RESTANTE", subtitulo: String(restante), titleColor: ColorConstants.midRisk, fontcolor: ColorConstants.midRisk, backColor: ColorConstants.lightMidRisk)
            }
        }
    }
}

#Preview {
    TextBox(montoRecibido: .constant("200"), montoTotal: 100000)
}
