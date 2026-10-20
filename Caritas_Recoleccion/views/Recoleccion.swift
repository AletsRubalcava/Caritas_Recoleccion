import SwiftUI

struct Recoleccion: View {
    @State private var showSheetConfirm = false
    @State private var irAReprogramar = false
    @State private var irAParcial = false
    @State private var colectionRegister = 2
    @State private var recoleccion : RecoleccionModel?
    @State private var estados : [EstadoRecoleccionModel]?
    @State private var Logout = false
    @State public var id : Int
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        ZStack {
                ScrollView {
                    VStack (spacing: 20){
                        
                        HStack {
                            Spacer()
                            Text("RECOLECCIÓN")
                                .font(.system(size: 32))
                                .foregroundStyle(ColorConstants.mainColor)
                                .bold()
                                .multilineTextAlignment(.trailing)
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text(recoleccion?.donante.uppercased() ?? "SIN NOMBRE")
                                .font(.system(size: 32))
                                .foregroundStyle(ColorConstants.mainColor)
                                .bold()
                            
                            HStack {
                                TextBubble(title: recoleccion?.estado.uppercased() ?? "DESCONOCIDO")
                                
                                Text((recoleccion?.fecha ?? "SIN FECHA").soloFecha)
                                    .font(.system(size: 12))
                                    .foregroundStyle(ColorConstants.lightGrayText)
                            }
                        }
                        .padding(.horizontal, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 100)
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.white)
                        }
                        
                        
                        BubbleWidget(
                            backgroundColor: ColorConstants.lightMainColor,
                            textColor: ColorConstants.mainColor,
                            title: "MONTO A RECOLECTAR",
                            value: "\(String(recoleccion?.montoARecolectar ?? 0)) PESOS",
                            valueFontSize: 40,
                            textAlignment: .center,
                            widgetAlignment: .center
                        ).frame(height: 100)
                        
                        InfoBox(
                            title: "DIRECCIÓN",
                            titleSize: 16,
                            icon: "mappin.and.ellipse"
                        ) {
                            VStack(alignment: .leading, spacing: 15) {
                                Text(recoleccion?.direccion ?? "DESCONOCIDA")
                                    .font(.system(size: 16))
                                    .foregroundStyle(ColorConstants.darkGray)
                                
                                if (recoleccion != nil) {
                                    HStack(spacing: 15) {
                                        Button("VER EN MAPAS") {
                                            abrirEnMapas(recoleccion!.direccion)
                                        }
                                        .buttonStyle(.bordered)
                                        .tint(ColorConstants.mainColor)
                                        .bold()
                                        .frame(maxWidth: .infinity)
                                    }
                                }
                            }
                            .padding(.horizontal, 22)
                            .padding(.vertical, 15)
                        }
                        
                        
                        InfoBox(title: "DETALLE DE LA PROMESA", titleSize: 16, icon: "doc", content: {
                            VStack (alignment: .leading){
                                Text("Campaña")
                                    .font(.system(size: 11))
                                    .foregroundStyle(ColorConstants.darkGray)
                                
                                Text(recoleccion?.campana ?? "DESCONOCIDA")
                                    .font(.system(size: 16))
                                    .bold()
                                HStack {
                                    
                                    ForEach(recoleccion?.tags ?? [], id: \.self) { tag in
                                            TextBubble(
                                                title: tag,
                                                background: ColorConstants.mainColor.opacity(0.1),
                                                fontColor: ColorConstants.mainColor
                                            )
                                        }                                }
                                InfoRow(icon: "calendar", text: "Fecha programada", value: (recoleccion?.fecha ?? "SIN FECHA").soloFecha)
                                InfoRow(icon: "dollarsign.circle", text: "Forma de pago", value: recoleccion?.metodoPago ?? "DESCONOCIDO")
                                InfoRow(icon: "repeat", text: "Frecuencia", value: recoleccion?.frecuencia ?? "DESCONOCIDA")
                                Divider()
                            }.padding()
                        })
                        
                        InfoBox(
                            title: "REGISTRAR RECOLECCIÓN",
                            titleSize: 16,
                            icon: "doc"
                        ) {
                            VStack (alignment: .leading){
                                Text("Selecciona el resultado de la visita al donante.").font(.system(size: 12)).foregroundStyle(ColorConstants.darkGray).padding(.bottom, 10)
                                
                                Picker(selection: $colectionRegister, label: Text("Registrar Colección")) {
                                    ForEach(estados ?? [], id: \.idEstado) { estado in
                                        Text(estado.nombre).tag(estado.idEstado)
                                    }
                                }
                                .pickerStyle(.segmented)
                                .padding(.bottom, 10)
                                
                                switch colectionRegister {
                                case 2:
                                    TextBubble(title: "Se registrará el cobro total de $\(recoleccion?.montoARecolectar ?? 0) pesos y se marcará como COMPLETADA",
                                               icon: "checkmark",
                                               fontColor: ColorConstants.lowRisk, expanded: true).padding(.bottom, 10)
                                        .frame(height: 50)
                                    
                                case 6:
                                    TextBubble(title: "La recolección se marcará como PARCIALMENTE RECOLECTADA.",
                                               icon: "circle.lefthalf.filled",
                                               fontColor: ColorConstants.midRisk, expanded: true).padding(.bottom, 10)
                                        .frame(height: 50)
                                    
                                case 3:
                                    TextBubble(title: "La recolección se marcará como NO RECOLECTADA.",
                                               icon: "xmark",
                                               fontColor: ColorConstants.highRisk, expanded: true).padding(.bottom, 10)
                                        .frame(height: 50)
                                    
                                default:
                                    TextBubble(title: "Se registrará el cobro total de $\(recoleccion?.montoARecolectar ?? 0) pesos y se marcará como COMPLETADA",
                                               icon: "checkmark",
                                               fontColor: ColorConstants.lowRisk, expanded: true).padding(.bottom, 10)
                                        .frame(height: 50)
                                    
                                }
                                
                                HStack{
                                    Spacer()
                                    Button("Registrar Recolección") {
                                        switch colectionRegister {
                                        case 3:  irAReprogramar = true
                                        case 6:  irAParcial = true
                                        default: showSheetConfirm = true
                                        }
                                    }                                    .buttonStyle(.borderedProminent)
                                    .tint(ColorConstants.mainColor)
                                    .bold()
                                    Spacer()
                                }
                                
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                        }.padding(.bottom, 30)
                        
                    }.padding()
            }
        }.background(ColorConstants.background)
            .sheet(isPresented: $showSheetConfirm, onDismiss: {
                Task { await cargarRecoleccion() }
            }) {
                if let recoleccion {
                    SheetRecoleccion(
                        idRecoleccion: id,
                        idEstado: colectionRegister,
                        nombreDonante: recoleccion.donante
                    ) {
                        VStack {
                            InfoRow(icon: "calendar", text: "Fecha programada", value: (recoleccion.fecha).soloFecha)
                            InfoRow(icon: "dollarsign.circle", text: "Forma de pago", value: recoleccion.metodoPago)
                            InfoRow(icon: "repeat", text: "Frecuencia", value: recoleccion.frecuencia)
                            Divider()
                        }
                    }
                    .presentationDetents([.medium])
                }
            }
            .task {
                do {
                    recoleccion = try await RecoleccionService.getRecoleccion(id: id)
                    print(recoleccion!)
                    
                    estados = try await RecoleccionService.getEstadosRecoleccion()
                    print(estados!)
                    
                } catch {
                    print("Error obteniendo donante: \(error)")
                }
            }
            .navigationDestination(isPresented: $irAReprogramar) {
                Reprogramar(idRecoleccion: id)
            }
            .navigationDestination(isPresented: $irAParcial) {
                if let recoleccion {
                    PagoParcial(idRecoleccion: id)
                }
            }
    }
    
    private func abrirEnMapas(_ direccion: String) {
        var components = URLComponents(string: "https://maps.apple.com/")!
        components.queryItems = [URLQueryItem(name: "q", value: direccion)]
        
        if let url = components.url {
            openURL(url)
        }
    }
    
    private func cargarRecoleccion() async {
        do {
            recoleccion = try await RecoleccionService.getRecoleccion(id: id)
        } catch {
            print("Error obteniendo recolección: \(error)")
        }
    }
}

extension String {
    var soloFecha: String {
        let formatosEntrada = [
            "yyyy-MM-dd'T'HH:mm:ss.SSS",
            "yyyy-MM-dd'T'HH:mm:ss",
            "yyyy-MM-dd HH:mm:ss",
            "yyyy-MM-dd",
            "EEE, dd MMM yyyy HH:mm:ss zzz"
        ]

        let entrada = DateFormatter()
        entrada.locale = Locale(identifier: "en_US_POSIX")
        entrada.timeZone = TimeZone(secondsFromGMT: 0)

        let salida = DateFormatter()
        salida.locale = Locale(identifier: "es_MX")
        salida.timeZone = TimeZone(secondsFromGMT: 0)
        salida.dateFormat = "dd/MM/yyyy"

        for formato in formatosEntrada {
            entrada.dateFormat = formato
            if let fecha = entrada.date(from: self) {
                return salida.string(from: fecha)
            }
        }
        return self
    }
}

#Preview {
    Recoleccion(id: 1)
}
