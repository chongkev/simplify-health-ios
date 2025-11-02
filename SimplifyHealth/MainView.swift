//
//  MainView.swift
//  SimplifyHealth
//
//  Created by Kevin Chong on 1/11/2025.
//

import SwiftUI

struct MainView: View {
/*    // Determine the columns based on the size class
    var columns: [GridItem] {
        // Compact width (iPhone portrait) -> 2 columns
        if horizontalSizeClass == .compact {
            return [GridItem(.flexible()), GridItem(.flexible())]
        }
        // Regular width (iPad, iPhone landscape/Plus/Max, etc.) -> 4 columns
        else {
            return Array(repeating: .init(.flexible()), count: 4)
        }
    }*/

    let columns = [
        GridItem(.adaptive(minimum: 220), spacing: 20)
    ]
    
    // Sample data for the tiles
    let items = [
        Item(name: "Pysiotherapy", iconSystemName: "figure.rolling", color: Color(red: 75/255.0, green: 125/255.0, blue: 116/255.0)),
        Item(name: "Occupational Therapy", iconSystemName: "figure.walk", color: Color(red: 116/255.0, green: 78/255.0, blue: 32/255.0)),
        Item(name: "Dietetics", iconSystemName: "frying.pan", color: Color(red: 90/255.0, green: 144/255.0, blue: 200/255.0)),
        Item(name: "Speech Pathlogy", iconSystemName: "voiceover", color: Color(red: 199/255.0, green: 105/255.0, blue: 106/255.0)),
        Item(name: "Fails Prevention", iconSystemName: "figure.fall", color: Color(red: 236/255.0, green: 223/255.0, blue: 205/255.0)),
        Item(name: "Home Safety Audit", iconSystemName: "house.lodge", color: Color(red: 84/255.0, green: 70/255.0, blue: 135/255.0)),
        Item(name: "Telehealth How-To", iconSystemName: "stethoscope", color: Color(red: 253/255.0, green: 159/255.0, blue: 40/255.0)),
        Item(name: "Contact Us", iconSystemName: "bubble.left.and.bubble.right", color: Color(red: 11/255.0, green: 38/255.0, blue: 53/255.0)),
    ]
    
    init() {
        UIScrollView.appearance().bounces = false
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    Text("Simplify Health")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                        .opacity(0.75)
                        .padding(.bottom, 28)

                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(items, id: \.name) { item in
                            TileView(
                                title: item.name,
                                iconSystemName: item.iconSystemName,
                                color: item.color,
                                height: isLandscape(geometry) ? 280 : 300)
                        }
                    }
                }
//                .scrollBounceBehavior(.basedOnSize)
            }
            .padding(32)
            .background(Color(red: 3.0/255.0, green: 50.0/255.0, blue: 70.0/255.0).ignoresSafeArea())
//            .navigationTitle("Simplify Health")
        }
        .navigationViewStyle(.stack)
    }
    
    func isLandscape(_ geometry: GeometryProxy) -> Bool { geometry.size.width > geometry.size.height }
}

struct Item {
    let name: String
    let iconSystemName: String
    let color: Color
}

struct TileView: View {
    let title: String
    let iconSystemName: String
    let color: Color
    let height: CGFloat
    
    var body: some View {
        Button(action: { print("Tapped \(title)") }) {
            VStack {
                Image(systemName: iconSystemName)
                    .font(.system(size: 80, weight: .bold))
                    .foregroundColor(color.useWhiteText ? .white : .black.opacity(0.75))
                    .frame(maxHeight: .infinity)
                Text(title)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(color.useWhiteText ? .white : .black.opacity(0.75))
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
            }
            .frame(height: height) // Give the tile a fixed height
            .frame(maxWidth: .infinity) // Important for flexible width
        }
        .buttonStyle(TappableStyle(color: color))
        .contentShape(Rectangle()) // Ensures the whole tile is tappable
        .cornerRadius(10)
    }
}

struct TappableStyle: ButtonStyle {
    let color: Color
    var pressedColor: Color { color.opacity(0.5) }
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? pressedColor : color)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

extension Color {
    var useWhiteText: Bool {
        let uiColor = UIColor(self)
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return brightness < 0.8
    }
}

#Preview {
    MainView()
}
