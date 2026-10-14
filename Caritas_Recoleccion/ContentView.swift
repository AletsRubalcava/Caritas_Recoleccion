import SwiftUI
import Charts

struct ContentView: View {
    @State private var Logout = false
    @State private var Filtro = 1
    @State private var listaRecolecciones: Array<RecoleccionSiguiente> = [
        RecoleccionSiguiente(apellidoPaterno: "Melanie", fecha: "30/09/2026", monto: 11236, nombre: "Rivera"),
        RecoleccionSiguiente(apellidoPaterno: "Garza", fecha: "12/09/2026", monto: 10236, nombre: "Samuel"),
        RecoleccionSiguiente(apellidoPaterno: "Vargas", fecha: "12/10/2026", monto: 13236, nombre: "Hector")
    ]
    
    @State private var listaRecSemanal = [
        RecoleccionesSemanales(diaSemana: "L", total: 4),
        RecoleccionesSemanales(diaSemana: "M", total: 2),
        RecoleccionesSemanales(diaSemana: "X", total: 3),
        RecoleccionesSemanales(diaSemana: "J", total: 5),
        RecoleccionesSemanales(diaSemana: "V", total: 5),
        RecoleccionesSemanales(diaSemana: "S", total: 2),
        RecoleccionesSemanales(diaSemana: "D", total: 3)
    ]
    @State private var recPendientes = 0
    @State private var recHoy = 0
    @State private var montoProyectado = 0
    
    let recoleccionesService = RecMainService()
    

    var body: some View {
        NavigationStack {
        VStack {
            Header(logout: $Logout)
                
                ScrollView {
                    VStack {
                        HStack {
                            Spacer()
                            Text("SOLICITUDES")
                                .font(.system(size: 45))
                                .bold()
                                .foregroundStyle(ColorConstants.mainColor)
                                .padding()
                        }
                        HStack {
                            VStack(alignment: .leading) {
                                Text("RECOLECCIONES PENDIENTES")
                                    .bold()
                                    .padding(.top, 15)
                                    .padding(.leading, 15)
                                    .padding(.trailing, 15)
                                Text("\(recPendientes)")
                                    .task {
                                        await cargarRecPendientes()
                                    }
                                    .bold()
                                    .font(.largeTitle)
                                    .padding(.bottom, 15)
                                    .padding(.leading, 15)
                            }
                            .padding(.trailing, 4)
                            .background(Color(.gray.opacity(0.2)))
                            .cornerRadius(20)
                            
                            VStack(alignment: .leading) {
                                Text("RECOLECCIONES EN PROCESO")
                                    .bold()
                                    .padding(.top, 15)
                                    .padding(.leading, 15)
                                    .padding(.trailing, 15)
                                Text("\(recHoy)")
                                    .task {
                                        await cargarRecHoy()
                                    }
                                    .bold()
                                    .font(.largeTitle)
                                    .padding(.bottom, 15)
                                    .padding(.leading, 15)
                            }
                            .padding(.leading, 4)
                            .background(Color(.gray.opacity(0.2)))
                            .cornerRadius(20)
                            
                        }
                        VStack {
                            VStack {
                                Text("RECOLECCIÓN PROYECTADA")
                                    .font(.system(size: 20))
                                    .bold()
                                    .foregroundStyle(ColorConstants.mainColor)
                                HStack {
                                    Spacer()
                                    Text("\(montoProyectado)")
                                        .task {
                                            await cargarMontoProyectado()
                                        }
                                        .font(.system(size: 60))
                                        .bold()
                                        .foregroundStyle(ColorConstants.mainColor)
                                    Text("Pesos")
                                        .font(.system(size: 30))
                                        .bold()
                                        .foregroundStyle(ColorConstants.mainColor)
                                    Spacer()
                                }
                            }
                            .padding()
                            .background(Color(.cyan.opacity(0.15)))
                            .cornerRadius(20)
                            .background(Color(.white))
                            .cornerRadius(20)
                            .padding(.horizontal, 15)
                            Chart(listaRecSemanal){ item in
                                BarMark(
                                    x: .value("Día", item.diaSemana),
                                    y: .value("Total", item.total)
                                )
                                .foregroundStyle(ColorConstants.mainColor)
                            }
                            .task {
                                await cargarRecPorDia()
                            }
                            .padding()
                            .frame(height: 220)
                            Picker(selection: $Filtro, label: Text("")){
                                Text("PRÓXIMAS").tag(1)
                                Text("MAYOR DONACIÓN").tag(2)
                            }.pickerStyle(.segmented)
                                .padding(.horizontal, 15)
                            VStack(spacing: 0) {
                                ForEach(listaRecolecciones) { recoleccionItem in
                                    NavigationLink {
                                        Recoleccion(id: 1)
                                    }
                                    label: {
                                        RecoleccionRow(recoleccionSig: recoleccionItem)
                                    }
                                }
                            }
                            .task {
                                await cargarLista()
                            }
                            .onChange(of: Filtro) { _ in
                                Task { await cargarLista() }
                            }
                        }.background(Color(.gray.opacity(0.05)))
                    }
                }
            }.ignoresSafeArea()
        }
    }
    private func cargarLista() async {
            if Filtro == 1 {
                do {
                    listaRecolecciones = try await RecoleccionesService.getListaRecoleccionesProx()
                } catch {
                    print("Error en llamada: \(error)")
                }
            } else {
                do {
                    listaRecolecciones = try await RecoleccionesService.getListaRecoleccionesProxByMonto()
                } catch {
                    print("Error en llamada: \(error)")
                }
            }
        }
    
    private func cargarRecPorDia() async {
        do {
            listaRecSemanal = try await RecoleccionesService.getListaRecPorDia()
        } catch {
            print("Error en llamada: \(error)")
        }
    }
    
    private func cargarRecPendientes() async {
        do {
            recPendientes = try await RecoleccionesService.getNumRecSemanal()
        } catch {
            print("Error en llamada: \(error)")
        }
    }
    
    private func cargarRecHoy() async {
        do {
            recHoy = try await RecoleccionesService.getNumRecHoy()
        } catch {
            print("Error en llamada: \(error)")
        }
    }
    
    private func cargarMontoProyectado() async {
        do {
            montoProyectado = try await RecoleccionesService.getMontoSumRec()
        } catch {
            print("Error en llamada: \(error)")
        }
    }
}

#Preview {
    ContentView()
}
