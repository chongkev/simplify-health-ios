//
//  VideoView.swift
//  SimplifyHealth
//
//  Created by Kevin Chong on 11/11/2025.
//

import SwiftUI
import AVKit

public struct VideoView: View {
    let item: VideoItem
    let backgroundColor: Color
    private let player: AVPlayer
    @State private var isPresentingPlayer = false
    
    init(item: VideoItem, backgroundColor: Color) {
        self.item = item
        self.backgroundColor = backgroundColor
        player = AVPlayer(url: URL(string: item.url)!)
    }
    
    public var body: some View {
        ScrollView {
            VStack {
                Text(item.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(backgroundColor.useWhiteText ? .white : .black.opacity(0.75))
                
                Text(item.description)
                    .multilineTextAlignment(.leading)
                    .font(.title)
                    .foregroundColor(backgroundColor.useWhiteText ? .white : .black.opacity(0.75))
                
                Button(action: { isPresentingPlayer = true }) {
                    ZStack {
                        AsyncImage(url: URL(string: item.thumbnailURL)!) { image in
                            image.resizable()
                                .scaledToFit()
                        } placeholder: {
                            Color.gray
                        }
                        .frame(maxWidth: .infinity)
                        .aspectRatio(16/9, contentMode: .fit)
                        
                        Image(systemName: "play.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.white)
                            .shadow(radius: 10)
                    }
                }
            }
            .padding(32)
        }
        .fullScreenCover(
            isPresented: $isPresentingPlayer,
            onDismiss: { player.pause() }
        ) {
            ZStack {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.white)
                    .scaleEffect(2)
                VideoPlayerController(player: player)
                    .ignoresSafeArea()
                    .onAppear {
                        player.play()
                    }
            }
            .background(.black)
        }
        .background(Config.primaryBackgroundGradient.ignoresSafeArea())
    }
}

struct VideoPlayerController: UIViewControllerRepresentable {
    let player: AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = true
        controller.view.backgroundColor = .clear
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}
}

#Preview {
    VideoView(item: .init(title: "", description: "", url: "", thumbnailURL: ""), backgroundColor: .brown)
}
