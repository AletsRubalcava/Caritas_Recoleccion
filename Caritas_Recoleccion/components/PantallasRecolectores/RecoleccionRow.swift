//
//  RecoleccionRow.swift
//  BOCETO_CARITAS
//
//  Created by Alumno on 10/09/26.
//

import SwiftUI

struct RecoleccionRow: View {
        
    @State public var recoleccionSig: RecoleccionSiguiente
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                VStack(alignment: .leading) {
                    Text("\(recoleccionSig.nombre) \(recoleccionSig.apellidoPaterno)")
                        .font(.title)
                        .bold()
                        .foregroundStyle(ColorConstants.mainColor)
                    Text("Recoleccion en \(formatDate(recoleccionSig.fecha))")
                        .font(.system(size: 20))
                    
                }
                .padding(.trailing, 30)
                VStack {
                    Text("Donación")
                        .font(.system(size: 20))
                    Text("$\(recoleccionSig.monto)")
                        .font(.title)
                        .bold()
                }
                Spacer()
            }
        }
        .padding()
        .cornerRadius(20)
        .padding()
    }
}

#Preview {
    let recoleccionSigPrueba = RecoleccionSiguiente(apellidoPaterno: "Rivera", fecha: "12/09/2026", monto: 10236, nombre: "Melanie")
    RecoleccionRow(recoleccionSig: recoleccionSigPrueba)
}
