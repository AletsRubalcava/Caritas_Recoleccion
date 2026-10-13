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
    var body: some View {
        HStack{
            VStack(alignment:.leading){
                Text("John Doe")
                    .foregroundStyle(ColorConstants.mainColor)
                    .font(.system(size: 20))
                    .bold()
                Text("Avenida pato xxxx, centro")
                    .foregroundStyle(ColorConstants.lightGrayText)
                    .bold()
            }
            Spacer()
            VStack{
                Text("PROMESA")
                    .foregroundStyle(ColorConstants.darkGray)
                Text("$10,000")
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
    PromesaBubble()
}
