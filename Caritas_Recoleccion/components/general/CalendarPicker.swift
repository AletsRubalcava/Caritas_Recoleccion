//
//  CalendarPicker.swift
//  Caritas_Recoleccion
//
//  Created by Alumno on 09/10/26.
//

import SwiftUI

struct CalendarPicker: View {
    @Binding var nuevaFecha: Date
    var fechaActual: Date
    var dateFormatter: DateFormatter{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 16){
            Text("NUEVA FECHA DE RECOLECCION")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundStyle(ColorConstants.darkGray)
            
            HStack(spacing: 8){
                Image(systemName: "clock.arrow.circlepath")
                    .foregroundColor(ColorConstants.highRisk)
                Text("Recolección actual: \(dateFormatter.string(from:fechaActual))")
                    .font(.system(size:14,weight: .medium))
                    .foregroundStyle(ColorConstants.darkGray)
            }
            .padding(.horizontal, 4)
            
            DatePicker("Selecciona la nueva fecha",
                       selection: $nuevaFecha,
                       displayedComponents: .date)
            .datePickerStyle(.graphical)
            .accentColor(ColorConstants.mainColor)
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            Text("Solo puedes elegir una fecha posterior a la recoleccion actual")
                .font(Font.system(size: 12, weight: .regular, design: .default))
                .foregroundStyle(ColorConstants.lightGrayText)
        }
    }
}

#Preview {
    CalendarPicker(nuevaFecha: .constant(Date().addingTimeInterval(86400 * 4)), fechaActual: Date())
}
