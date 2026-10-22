import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""

    @State private var showAlert = false
    @State private var messageAlert = ""
    @State private var usuarioLogquado: LoginResponse? = nil
    @State private var estaLogueado: Bool = false

    private let colorPrincipal = Color(red: 0, green: 152/255, blue: 174/255)
    private let colorCampo = Color(red: 191/255, green: 190/255, blue: 186/255)

    private func verificacionLogin() {
        Task {
            do {
                if username == "" || password == "" {
                    showAlert.toggle()
                    messageAlert = "Favor de rellenar todos los campos"
                } else {
                    let request = LoginRequest(userName: username, password_hash: password)
                    let response = try await verificarLogin(request)

                    if response.error != nil {
                        showAlert.toggle()
                        messageAlert = "El correo o la contraseña son incorrectos"
                    } else {
                        usuarioLogquado = response
                        Sesion.shared.token = response.token
                        if response.idRol == 3 {
                            estaLogueado = true
                        } else {
                            showAlert.toggle()
                            messageAlert = "No cuentas con los permisos necesarios"
                        }
                    }
                }
            } catch {
                print("\(error)")
                showAlert.toggle()
                messageAlert = "Error en la conexión"
            }
        }
    }

    private func campo<Content: View>(_ titulo: String, @ViewBuilder contenido: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(titulo)
                .font(.system(size: 18, weight: .bold))
            contenido()
                .font(.system(size: 16))
                .padding(.horizontal, 16)
                .frame(height: 52)
                .background(colorCampo)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(colorPrincipal, lineWidth: 3)
                )
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    Image("Caritas-Photoroom")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 70)
                        .padding(.leading, 24)
                        .padding(.vertical, 8)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .background {
                    Color.white
                        .shadow(color: .gray.opacity(0.6), radius: 8, y: 3)
                        .ignoresSafeArea(edges: .top)
                }
                .zIndex(1)

                ScrollView {
                    VStack(spacing: 0) {
                        Image("Logo Cara y Cruz")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 100)
                            .padding(.top, 36)

                        Text("CARA Y CRUZ")
                            .font(.system(size: 36, weight: .heavy))
                            .padding(.top, 8)
                            .padding(.bottom, 32)

                        VStack(alignment: .leading, spacing: 18) {
                            Text("INICIAR SESIÓN")
                                .font(.system(size: 24, weight: .bold))

                            Divider()

                            campo("USUARIO") {
                                TextField("caritas@gmail.com", text: $username)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                                    .keyboardType(.emailAddress)
                            }

                            campo("CONTRASEÑA") {
                                SecureField("•••••••", text: $password)
                            }

                            Button {
                                verificacionLogin()
                            } label: {
                                Text("INICIAR SESIÓN")
                                    .font(.system(size: 20, weight: .bold))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                            }
                            .buttonStyle(.borderedProminent)
                            .buttonBorderShape(.roundedRectangle(radius: 20))
                            .tint(colorPrincipal)
                            .padding(.top, 12)
                            .alert("\(messageAlert)", isPresented: $showAlert) {
                                Button("OK") {}
                            }
                        }
                        .padding(.horizontal, 28)
                        .padding(.vertical, 28)
                        .background(.white.opacity(0.85))
                        .clipShape(RoundedRectangle(cornerRadius: 32))
                        .overlay {
                            RoundedRectangle(cornerRadius: 32)
                                .stroke(.gray, lineWidth: 1)
                        }
                        .shadow(color: .gray.opacity(0.6), radius: 10)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 32)
                    }
                    .frame(maxWidth: 500)
                    .frame(maxWidth: .infinity)
                }
                .scrollBounceBehavior(.basedOnSize)
                .scrollDismissesKeyboard(.interactively)
            }
            .background {
                LinearGradient(
                    colors: [
                        Color(red: 195/255, green: 230/255, blue: 228/255),
                        colorPrincipal
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            }
            .navigationDestination(isPresented: $estaLogueado) {
                ContentView(idUsuario: usuarioLogquado?.idUsuario ?? 0)
            }
            .onChange(of: estaLogueado) { _, nuevo in
                if !nuevo {
                    username = ""
                    password = ""
                    usuarioLogquado = nil
                }
            }
        }
        .preferredColorScheme(.light)
    }
}

#Preview {
    LoginView()
}
