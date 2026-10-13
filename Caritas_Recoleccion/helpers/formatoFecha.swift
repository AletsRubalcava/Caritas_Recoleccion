//
//  formatoFecha.swift
//  BOCETO_CARITAS
//
//  Created by Rogelio Iram González Ortiz on 23/09/26.
//

import Foundation

func formatoFecha(_ meses: Int) -> String {
    if meses >= 12 && meses % 12 == 0 {
        let años = meses / 12
        return "Última donación hace \(años) \(años == 1 ? "año" : "años")"
    }
    return "Última donación hace \(meses) meses"
}
