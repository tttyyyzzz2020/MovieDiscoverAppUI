//
//  FullBackgroundView.swift
//  MovieDiscoverAppUI
//
//  Created by yongzhan on 2020/6/20.
//  Copyright © 2020 yongzhan. All rights reserved.
//

import SwiftUI

struct FullBackgroundView: View {
    @ObservedObject var imageLoader: ImageLoader
    var body: some View {
        ZStack {
            GeometryReader { gr in
                if self.imageLoader.image != nil {
                    Image(uiImage: self.imageLoader.image!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: gr.frame(in: .global).width,
                               height: gr.frame(in: .global).height)
                        .blur(radius: 50)
                        .overlay(Color.black.opacity(0.5))
                } else {
                    Rectangle()
                        .foregroundColor(Color.black.opacity(0.2))
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct FullBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        FullBackgroundView(imageLoader: ImageLoaderCache.shared.loadedFor(with: Movie.stubbedMovies.last!.poster_path, size: .medium))
    }
}
