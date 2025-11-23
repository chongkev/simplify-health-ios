//
//  Config.swift
//  SimplifyHealth
//
//  Created by Kevin Chong on 23/11/2025.
//

import SwiftUI

/// App-wide configuations
enum Config {
    
    static var primaryBackgroundColor: Color {
        Color(red: 3.0/255.0, green: 50.0/255.0, blue: 70.0/255.0)
    }
    
    static var primaryBackgroundGradient: some View {
        LinearGradient(
            stops: [
                .init(color: primaryBackgroundColor, location: 0.0),
                .init(color: primaryBackgroundColor, location: 0.15),
                .init(color: primaryBackgroundColor.brighten(by: -0.07), location: 0.5),
                .init(color: primaryBackgroundColor.brighten(by: -0.03), location: 1),
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    static var primaryTint: Color {
        Color(red: 54.0/255.0, green: 115/255.0, blue: 72.0/255.0)
    }
}
