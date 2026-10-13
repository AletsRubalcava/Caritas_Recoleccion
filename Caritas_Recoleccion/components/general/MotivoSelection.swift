//
//  MotivoSelection.swift
//  Caritas_Recoleccion
//
//  Created by Alumno on 09/10/26.
//

import SwiftUI

struct MotivoSelection: View {
    @Binding var motivoSeleccionado: String
    let motivos = [
        "No se encontraba",
        "Sin fondos",
        "Pidio otra fecha",
        "Direccion incorrecta",
        "Otro"
    ]
    var body: some View {
        VStack(alignment: .leading, spacing: 12){
            Text("MOTIVO")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(ColorConstants.darkGray)
            HStack{
                Picker("Selecciona un motivo", selection: $motivoSeleccionado){
                    ForEach(motivos, id: \.self){ motivo in
                        Text(motivo).tag(motivo)
                    }
                }
                .pickerStyle(.menu)
                .accentColor(ColorConstants.mainColor)
                Spacer()
            }
        }
    }
}

#Preview {
    MotivoSelection(motivoSeleccionado:.constant("No se encontraba"))
}
