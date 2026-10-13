//
//  headerMobile.swift
//  BOCETO_CARITAS
//
//  Created by Ruben Castro on 23/09/2026.
//

import SwiftUI

struct headerMobile: View {
    @Binding var logout: Bool
    var body: some View {
            HStack {
                HStack {
                    Image("Caritas-Photoroom")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                    Spacer()
                    Button{
                        logout = true
                    }
                    label: {
                        Text("Log out")
                            .frame(maxWidth: 100)
                            .padding(.top, 5)
                            .padding(.bottom, 5)
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                        
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle(radius: 20))
                    .frame(maxWidth: 100)
                    .tint(Color(red:0, green: 152/255, blue: 174/255))
                    .font(.system(size: 20))
                }
                .padding(.horizontal, 40)
            }
            .background {
                Rectangle()
                    .fill(.white)
                    .shadow(radius: 5, y: 10)
            }
        }
    }


#Preview {
    @Previewable @State var logoutPrueba = false
    headerMobile(logout: $logoutPrueba)
}
