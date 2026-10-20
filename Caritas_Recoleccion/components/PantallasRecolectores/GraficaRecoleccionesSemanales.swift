//
//  GraficaRecoleccionesSemanales.swift
//  BOCETO_CARITAS
//
//  Created by Alumno on 10/09/26.
//

import SwiftUI
import Charts

struct GraficaRecoleccionesSemanales: View {
    let listaRecoleccionesSemanales = [
        RecoleccionesSemanales(diaSemana: "L", total: 4),
        RecoleccionesSemanales(diaSemana: "M", total: 4),
        RecoleccionesSemanales(diaSemana: "X", total: 5),
        RecoleccionesSemanales(diaSemana: "J", total: 5),
        RecoleccionesSemanales(diaSemana: "V", total: 2),
        RecoleccionesSemanales(diaSemana: "S", total: 1),
        RecoleccionesSemanales(diaSemana: "D", total: 4),
    ]
    var body: some View {
        VStack {
            Chart(listaRecoleccionesSemanales){ item in
                BarMark(
                    x: .value("Escenario", item.diaSemana),
                    y: .value("Número de asistentes", item.total)
                ).foregroundStyle(ColorConstants.mainColor)
            }
        }
    }
}

#Preview {
    GraficaRecoleccionesSemanales()
}
