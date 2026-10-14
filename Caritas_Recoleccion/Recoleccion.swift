import SwiftUI

struct Recoleccion: View {
    @State private var showSheet = false
    @State private var colectionRegister = 1
    @State private var recoleccion : RecoleccionModel?
    @State private var Logout = false
    @State public var id : Int
    
    var body: some View {
        ZStack {
            ColorConstants.background
                ScrollView {
                    VStack {
                        Header(logout: $Logout)
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
                                
                                Text(recoleccion?.fecha ?? "SIN FECHA")
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
                                
                                HStack(spacing: 15) {
                                    Button("VER EN MAPAS") {
                                        
                                    }
                                    .buttonStyle(.bordered)
                                    .tint(ColorConstants.mainColor)
                                    .bold()
                                    .frame(maxWidth: .infinity)
                                    
                                    Button("LLAMAR") {
                                        
                                    }
                                    .buttonStyle(.bordered)
                                    .tint(ColorConstants.mainColor)
                                    .bold()
                                    .frame(maxWidth: .infinity)
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
                                InfoRow(icon: "calendar", text: "Fecha programada", value: recoleccion?.fecha ?? "DESCONOCIDA")
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
                                    Text("Completa").tag(1)
                                    Text("Parcial").tag(2)
                                    Text("No recolectada").tag(3)
                                }.pickerStyle(.segmented)
                                    .padding(.bottom, 10)
                                
                                switch colectionRegister {
                                case 1:
                                    TextBubble(title: "Se registrará el cobro total de $\(recoleccion?.montoARecolectar ?? 0) pesos y se marcará como COMPLETADA",
                                               icon: "checkmark",
                                               fontColor: ColorConstants.lowRisk, expanded: true).padding(.bottom, 10)
                                        .frame(height: 50)
                                    
                                case 2:
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
                                    TextBubble(title: "Se registrará el cobro total de $10,236 pesos.",
                                               icon: "checkmark",
                                               fontColor: ColorConstants.lowRisk, expanded: true).padding(.bottom, 10)
                                        .frame(height: 50)
                                    
                                }
                                
                                HStack{
                                    Spacer()
                                    Button("Registrar Recolección") {
                                        showSheet = true
                                    }
                                    .buttonStyle(.borderedProminent)
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
            }
        }.ignoresSafeArea()
            .sheet(isPresented: $showSheet) {
                SheetRecoleccion(content: {
                    VStack{
                        InfoRow(icon: "calendar", text: "Fecha programada", value: recoleccion!.fecha)
                        InfoRow(icon: "dollarsign.circle", text: "Forma de pago", value: recoleccion!.metodoPago)
                        InfoRow(icon: "repeat", text: "Frecuencia", value: recoleccion!.frecuencia)
                        Divider()
                    }
                }
                ).presentationDetents([.medium])
            }
            .task {
                do {
                    recoleccion = try await RecoleccionService.getRecoleccion(id: id)
                    print(recoleccion!)
                    
                    
                } catch {
                    print("Error obteniendo donante: \(error)")
                }
            }
    }
}

#Preview {
    Recoleccion(id: 1)
}
