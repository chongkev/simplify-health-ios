//
//  VideosView.swift
//  SimplifyHealth
//
//  Created by Kevin Chong on 2/11/2025.
//

import SwiftUI
import Combine

struct VideosView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @ObservedObject var viewModel: ViewModel

    var columns: [GridItem] {
//        Array(repeating: .init(.flexible()), count: horizontalSizeClass == .compact ? 1 : 2)
        [.init(.flexible())]
    }

    var body: some View {
        ScrollView {
            Text(viewModel.title)
                .font(.largeTitle)
                .bold()
                .foregroundColor(viewModel.backgroundColor.useWhiteText ? .white : .black.opacity(0.75))
                .opacity(0.75)
                .padding(.bottom, 28)

            LazyVGrid(columns: columns, spacing: 24) {
                ForEach(viewModel.items, id: \.title) { item in
                    VideoItemView(
                        videoItem: item,
                        backgroundColor: viewModel.backgroundColor.brighten(by: -0.2)
                    )
                    .padding(.horizontal, 24)
//                    .padding(.bottom, 24)
                }
            }
        }
        .background(viewModel.backgroundColor.ignoresSafeArea())
    }
}

struct VideoItemView: View {
    let videoItem: VideoItem
    let backgroundColor: Color
//    @State private var isPresentingFullScreenView = false
    
/*    var body: some View {
        Button(action: { isPresentingFullScreenView = true }) {
            HStack(alignment: .top) {
                RemoteImageView(imageURL: URL(string: thumbnailURL)!)
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .cornerRadius(10)
                    .padding(.trailing, 16)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(title)
                        .multilineTextAlignment(.leading)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(backgroundColor.useWhiteText ? .white : .black.opacity(0.75))
                    
                    Text(description)
                        .lineLimit(5)
                        .multilineTextAlignment(.leading)
                        .font(.title)
                        .foregroundColor(backgroundColor.useWhiteText ? .white : .black.opacity(0.75))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity)
            .padding(12)
        }
        .buttonStyle(TappableStyle(color: backgroundColor))
        .contentShape(Rectangle())
        .cornerRadius(10)
        .sheet(isPresented: $isPresentingFullScreenView) {
//        .fullScreenCover(isPresented: $isPresentingFullScreenView) {
            VideoView(item: .init(title: title, description: description, url: videoURL, thumbnailURL: thumbnailURL))
        }
    }*/
    
    var body: some View {
        NavigationLink(destination: VideoView(item: videoItem, backgroundColor: backgroundColor)) {
            HStack(alignment: .top) {
//                RemoteImageView(imageURL: URL(string: videoItem.thumbnailURL)!)
                CachedRemoteImageView(imageURL: URL(string: videoItem.thumbnailURL)!)
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(videoItem.title)
                        .multilineTextAlignment(.leading)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(backgroundColor.useWhiteText ? .white : .black.opacity(0.75))
                    
                    Text(videoItem.description)
                        .lineLimit(4)
                        .multilineTextAlignment(.leading)
                        .font(.title)
                        .foregroundColor(backgroundColor.useWhiteText ? .white : .black.opacity(0.75))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
            }
            .background(backgroundColor)
            .frame(maxWidth: .infinity)
            .cornerRadius(10)
        }
    }
}

struct VideoItem {
    let title: String
    let description: String
    let url: String
    let thumbnailURL: String
}


extension VideosView {
    class ViewModel: ObservableObject {
        let title: String
        let items: [VideoItem]
        let backgroundColor: Color
        init(
            title: String,
            items: [VideoItem],
            backgroundColor: Color
        ) {
            self.title = title
            self.items = items
            self.backgroundColor = backgroundColor
        }
    }
}

#Preview {
    VideosView(
        viewModel: .init(
            title: "Physiotherapy",
            items: Dummy.physiotherapyVideoItems,
            backgroundColor: Color(red: 75/255.0, green: 125/255.0, blue: 116/255.0)
        )
    )
}

extension Dummy {
    static let physiotherapyVideoItems: [VideoItem] = {
        [
            .init(title: "Video 1", description: "Stormi is a dog. She is dark grey and has long legs. Her eyes are expressive and are able to let her humans know what she is thinking. Her tongue is long, pink, and wet. Her long legs allow her to sprint after other dogs, people or bunnies. She can be a good dog, but also very bad. Her tail wags when happy or excited and hides between her back legs when she is bad. Stormi is a dog I love.", url: "https://harvesttech.com.au/vids/vid.mp4", thumbnailURL: "https://harvesttech.com.au/vids/w1v3-t.jpg"),
            .init(title: "Video 2", description: "It was a weird concept. Why would I really need to generate a random paragraph? Could I actually learn something from doing so? All these questions were running through her head as she pressed the generate button. To her surprise, she found what she least expected to see.", url: "https://harvesttech.com.au/vids/vid.mp4", thumbnailURL: "https://harvesttech.com.au/vids/w1v4-t.jpg"),
            .init(title: "Video 3", description: "The young man wanted a role model. He looked long and hard in his youth, but that role model never materialized. His only choice was to embrace all the people in his life he didn't want to be like.", url: "https://harvesttech.com.au/vids/vid.mp4", thumbnailURL: "https://harvesttech.com.au/vids/w1v5-t.jpg"),
            .init(title: "Video 4", description: "Bryan had made peace with himself and felt comfortable with the choices he made. This had made all the difference in the world. Being alone no longer bothered him and this was essential since there was a good chance he might spend the rest of his life alone in a cell.", url: "https://harvesttech.com.au/vids/vid.mp4", thumbnailURL: "https://harvesttech.com.au/vids/w1v6-t.jpg"),
            .init(title: "Video 5", description: "The lone lamp post of the one-street town flickered, not quite dead but definitely on its way out. Suitcase by her side, she paid no heed to the light, the street or the town. A car was coming down the street and with her arm outstretched and thumb in the air, she had a plan.", url: "https://harvesttech.com.au/vids/vid.mp4", thumbnailURL: "https://harvesttech.com.au/vids/w2v1-t.jpg"),
        ]
    }()
    static let occupationalTherapyVideoItems: [VideoItem] = { physiotherapyVideoItems }()
    static let dieteticsVideoItems: [VideoItem] = { physiotherapyVideoItems }()
    static let speechPathologyVideoItems: [VideoItem] = { physiotherapyVideoItems }()
    static let fallsPreventionVideoItems: [VideoItem] = { physiotherapyVideoItems }()
    static let homeSafetyAuditVideoItems: [VideoItem] = { physiotherapyVideoItems }()
    static let telehealthHowToVideoItems: [VideoItem] = { physiotherapyVideoItems }()
}
