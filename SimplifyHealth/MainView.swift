//
//  MainView.swift
//  SimplifyHealth
//
//  Created by Kevin Chong on 1/11/2025.
//

import SwiftUI
import Combine

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
    @ObservedObject private var viewModel: ViewModel
    @State private var showUserMenuPopover = false

    let columns = [
        GridItem(.adaptive(minimum: 220), spacing: 20)
    ]
    
    // Sample data for the tiles
    let items: [ItemType] = Dummy.mainViewItems
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        UIScrollView.appearance().bounces = false
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack(alignment: .top) {
                    ScrollView {
                        Spacer()
                            .frame(height: 64)
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(items, id: \.title) { item in
                                NavigationLink(destination: detailView(for: item)) {
                                    TileView(
                                        title: item.title,
                                        iconSystemName: item.iconSystemName,
                                        color: item.color,
                                        height: isLandscape(geometry) ? 280 : 300
                                    )
                                }
                            }
                        }
                        .padding(32)
                    }
//                    .scrollBounceBehavior(.basedOnSize)
                    
                    ZStack(alignment: .top) {
                        Text("Simplify Health")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                            .opacity(0.75)
                            .padding(.bottom, 28)
                        
                        HStack {
                            Spacer()
                            userMenuButton
                        }
                    }
                    .padding(.horizontal, 32)
                    .background(headerBackgroundColor.ignoresSafeArea())
                }
            }
            .background(backgroundColor.ignoresSafeArea())
//            .navigationTitle("Simplify Health")
        }
        .navigationViewStyle(.stack)
    }
    
    @ViewBuilder
    func detailView(for item: ItemType) -> some View {
        switch item {
        case let .contentCategory(title, _, color, videoItems):
            VideosView(
                viewModel: .init(
                    title: title,
                    items: videoItems,
                    backgroundColor: color
                )
            )
        case .contactUs:
            ContactUsView()
        }
    }
    
    var userMenuButton: some View {
        Button(action: { showUserMenuPopover = true }) {
            Image(systemName: "person.crop.circle")
                .font(.largeTitle)
                .foregroundStyle(.white)
                .opacity(0.4)
        }
        .popover(isPresented: $showUserMenuPopover, arrowEdge: .top) {
            VStack {
                Text("Signed in as \( viewModel.userName)")
                    .padding()
                Button("Logout") {
                    viewModel.sessionSignOut.signOut()
                }
                .buttonStyle(.bordered)
                .padding()
            }
            .frame(width: 400, height: 150)
            
        }
    }
    
    var backgroundColor: Color {
        Color(red: 3.0/255.0, green: 50.0/255.0, blue: 70.0/255.0)
    }
    
    var headerBackgroundColor: some View {
        backgroundColor.mask(
            LinearGradient(
                gradient: Gradient(colors: [.black, .black, .black, .black, .black.opacity(0)]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
    
    func isLandscape(_ geometry: GeometryProxy) -> Bool { geometry.size.width > geometry.size.height }
}

extension MainView {
    class ViewModel: ObservableObject {
        let sessionInfo: SessionInfo
        let sessionSignOut: SessionSignOut
        init(sessionInfo: SessionInfo, sessionSignOut: SessionSignOut) {
            self.sessionInfo = sessionInfo
            self.sessionSignOut = sessionSignOut
        }
        
        var userName: String {
            switch sessionInfo.sessionState {
            case let .signedIn(info): info.username
            case .signedOut: ""
            }
        }
    }
    
    enum ItemType {
        case contentCategory(
            title: String,
            iconSystemName: String,
            color: Color,
            videoItems: [VideoItem]
        )
        case contactUs
        
        var title: String {
            switch self {
            case let .contentCategory(title, _, _, _): title
            case .contactUs: "Contact Us"
            }
        }
        var iconSystemName: String {
            switch self {
            case let .contentCategory(_, iconSystemName, _, _): iconSystemName
            case .contactUs: "bubble.left.and.bubble.right"
            }
        }
        var color: Color {
            switch self {
            case let .contentCategory(_, _, color, _): color
            case .contactUs: Color(red: 11/255.0, green: 38/255.0, blue: 53/255.0)
            }
        }
    }
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
//        Button(action: { print("Tapped \(title)") }) {
        Group {
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
//        .buttonStyle(TappableStyle(color: color))
        .background(color)
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
    
    /// Darkens the color by a specified percentage (0.0 to 1.0)
    func brighten(by percentage: CGFloat = 0.2) -> Color {
        let uiColor = UIColor(self)
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        // Adjust the brightness, clamping the value between 0 and 1
        let newBrightness = max(0, min(1, brightness + percentage))
        
        // Create a new Color from the adjusted HSB values
        return Color(uiColor: UIColor(hue: hue, saturation: saturation, brightness: newBrightness, alpha: alpha))
    }
}

extension Dummy {
    static let mainViewItems: [MainView.ItemType] = {
        [
            .contentCategory(
                title: "Pysiotherapy",
                iconSystemName: "figure.rolling",
                color: Color(red: 75/255.0, green: 125/255.0, blue: 116/255.0),
                videoItems: Dummy.physiotherapyVideoItems
            ),
            .contentCategory(
                title: "Occupational Therapy",
                iconSystemName: "figure.walk",
                color: Color(red: 116/255.0, green: 78/255.0, blue: 32/255.0),
                videoItems: Dummy.occupationalTherapyVideoItems
            ),
            .contentCategory(
                title: "Dietetics",
                iconSystemName: "frying.pan",
                color: Color(red: 90/255.0, green: 144/255.0, blue: 200/255.0),
                videoItems: Dummy.dieteticsVideoItems
            ),
            .contentCategory(
                title: "Speech Pathlogy",
                iconSystemName: "voiceover",
                color: Color(red: 199/255.0, green: 105/255.0, blue: 106/255.0),
                videoItems: Dummy.speechPathologyVideoItems
            ),
            .contentCategory(
                title: "Falls Prevention",
                iconSystemName: "figure.fall",
                color: Color(red: 236/255.0, green: 223/255.0, blue: 205/255.0),
                videoItems: Dummy.fallsPreventionVideoItems
            ),
            .contentCategory(
                title: "Home Safety Audit",
                iconSystemName: "house.lodge",
                color: Color(red: 84/255.0, green: 70/255.0, blue: 135/255.0),
                videoItems: Dummy.homeSafetyAuditVideoItems
            ),
            .contentCategory(
                title: "Telehealth How-To",
                iconSystemName: "stethoscope",
                color: Color(red: 253/255.0, green: 159/255.0, blue: 40/255.0),
                videoItems: Dummy.telehealthHowToVideoItems
            ),
            .contactUs,
        ]
    }()
}

#Preview {
    MainView(viewModel: .init(sessionInfo: Dummy.sessionInfo, sessionSignOut: Dummy.sessionSignOut))
}
