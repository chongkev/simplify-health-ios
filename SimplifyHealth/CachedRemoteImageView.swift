//
//  CachedRemoteImageView.swift
//  SimplifyHealth
//
//  Created by Kevin Chong on 12/11/2025.
//

import SwiftUI

struct CachedRemoteImageView: View {
    let imageURL: URL
    @State private var uiImage: UIImage?
    
    var body: some View {
        if let uiImage {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
        } else {
            ProgressView()
                .onAppear { fetchImage() }
        }
    }
    
    private func fetchImage() {
        Task { @MainActor in
            uiImage = try? await getImage(from: imageURL)
        }
    }
}

private func getImage(from url: URL) async throws -> UIImage {
    if let image = cache.object(forKey: url as NSURL) {
        return image
    }
    let (data, _) = try await URLSession.shared.data(from: url)
    guard let image = UIImage(data: data) else {
        throw NSError(domain: "", code: 0)
    }
    cache.setObject(image, forKey: url as NSURL)
    return image
}

private let cache = NSCache<NSURL, UIImage>()


/*
struct RemoteImageView: View {
    let imageURL: URL
    var body: some View {
        AsyncImage(url: imageURL) { image in
            image
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
        } placeholder: {
            ProgressView() // Shows a loading indicator while the image is being fetched
        }
    }
}
*/
