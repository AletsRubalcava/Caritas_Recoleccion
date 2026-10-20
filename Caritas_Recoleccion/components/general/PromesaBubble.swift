//
//  PromesaBubble.swift
//  Caritas_Recoleccion
//
//  Created by Alumno on 09/10/26.
//


//
//  SwiftUIView.swift
//  Caritas_Recoleccion
//
//  Created by Alumno on 09/10/26.
//

import SwiftUI

struct PromesaBubble: View {
    let nombre: String
    let direccion: String
    let monto: Double
    var body: some View {
        HStack{
            VStack(alignment:.leading){
                Text(nombre)
                    .foregroundStyle(ColorConstants.mainColor)
                    .font(.system(size: 20))
                    .bold()
                Text(direccion)
                    .foregroundStyle(ColorConstants.lightGrayText)
                    .bold()
            }
            Spacer()
            VStack{
                Text("PROMESA")
                    .foregroundStyle(ColorConstants.darkGray)
                Text("$\(String(monto))")
                    .foregroundStyle(ColorConstants.darkGray)
                    .bold()
                    .font(.system(size: 20))
            }
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .padding(15)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    PromesaBubble(nombre: "John Doe", direccion: "Avenida pato xxxx, centro", monto: 10000)
}
