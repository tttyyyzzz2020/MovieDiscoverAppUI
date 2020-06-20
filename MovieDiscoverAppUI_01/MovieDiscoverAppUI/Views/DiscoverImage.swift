//
//  DiscoverImage.swift
//  MovieDiscoverAppUI
//
//  Created by yongzhan on 2020/6/20.
//  Copyright © 2020 yongzhan. All rights reserved.
//

import SwiftUI

struct DiscoverImage: View {
    @ObservedObject var imageLoader: ImageLoader
    var body: some View {
        ZStack {
            if self.imageLoader.image != nil {
                Image(uiImage: self.imageLoader.image!)
                    .resizable()
                    .aspectRatio(0.66, contentMode: .fit)
                    .frame(width: 245)
                    .cornerRadius(8)
            } else {
                Rectangle()
                    .foregroundColor(Color.black.opacity(0.2))
                    .aspectRatio(0.66, contentMode: .fit)
                    .frame(width: 245)
                    .cornerRadius(8)
            }
            
        }
    }
}

struct DiscoverImage_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverImage(imageLoader: ImageLoaderCache.shared.loadedFor(with: Movie.stubbedMovies.last!.poster_path, size: .medium))
    }
}
