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
                
                Button(action: { isPresentingPlayer = true }) {
                    ZStack {
                        CachedRemoteImageView(imageURL: URL(string: item.thumbnailURL)!) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(height: 280)
                                .aspectRatio(16/9, contentMode: .fit)
                                .clipped()
                        }
                        .frame(maxWidth: .infinity)
                        
                        Image(systemName: "play.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.white)
                            .shadow(radius: 10)
                    }
                }
                
                Text(item.description)
                    .multilineTextAlignment(.leading)
                    .font(.title)
                    .foregroundColor(backgroundColor.useWhiteText ? .white : .black.opacity(0.75))
                    .padding(32)
            }
//            .padding(32)
        }
        .frame(maxWidth: .infinity)
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
    VideoView(
        item: .init(
            title: "Video 1",
            description: "Stormi is a dog. She is dark grey and has long legs. Her eyes are expressive and are able to let her humans know what she is thinking. Her tongue is long, pink, and wet. Her long legs allow her to sprint after other dogs, people or bunnies. She can be a good dog, but also very bad. Her tail wags when happy or excited and hides between her back legs when she is bad. Stormi is a dog I love.",
            url: "https://harvesttech.com.au/vids/vid.mp4",
            thumbnailURL: "https://harvesttech.com.au/vids/w1v3-t.jpg"
        ),
        backgroundColor: .brown
    )
}
