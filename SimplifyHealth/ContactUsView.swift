//
//  ContactUsView.swift
//  SimplifyHealth
//
//  Created by Kevin Chong on 15/11/2025.
//

import SwiftUI

struct ContactUsView: View {
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                Text("Contact Us")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .opacity(0.75)
                    .frame(maxWidth: .infinity)
                
                tile(
                    iconSystemName: "envelope.circle.fill",
                    title: "Send us email",
                    infoView: linkView(
                        title: "info@simplifyhealth.net.au",
                        url: URL(string: "mailto:info@simplifyhealth.net.au")!
                    ),
                    description: "Get a quick response from our friendly team.",
                    geometry: geometry
                )
                
                tile(
                    iconSystemName: "phone.circle.fill",
                    title: "Call us now",
                    infoView: linkView(
                        title: "+61 9202 6800",
                        url: URL(string: "tel:+6192026800")!
                    ),
                    description: "Speak with us directly during business hours.",
                    geometry: geometry
                )
                
                tile(
                    iconSystemName: "square.and.pencil.circle.fill",
                    title: "Write to us",
                    infoView: Text("PO Box 1118\nOsborne Park\nWA 6017")
                        .multilineTextAlignment(.center)
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                        .opacity(0.75),
                    description: "Send your formal correspondence via postal mail.",
                    geometry: geometry
                )
            }
            .background(Color(red: 11/255.0, green: 38/255.0, blue: 53/255.0))
        }
    }
    
    func tile(
        iconSystemName: String,
        title: String,
        infoView: some View,
        description: String,
        geometry: GeometryProxy
    ) -> some View {
        VStack(spacing: 12) {
            Image(systemName: iconSystemName)
                .font(.system(size: 60))
                .foregroundColor(.white)
                .opacity(0.75)
            Text(title)
                .multilineTextAlignment(.center)
                .font(.title)
                .bold()
                .foregroundColor(.white)
                .opacity(0.75)
            infoView
            Text(description)
                .multilineTextAlignment(.center)
                .font(.title)
                .foregroundColor(.white)
                .opacity(0.75)
                .frame(maxWidth: min(geometry.size.width * 0.75, 600))
        }
        .padding(24)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.white.opacity(0.2), lineWidth: 2)
        )
        .padding(.horizontal, 36)
        .padding(.bottom, 36)
    }
    
    func linkView(title: String, url: URL) -> some View {
        Link(title, destination: url)
            .font(.title)
            .bold()
    }
}

#Preview {
    ContactUsView()
}

