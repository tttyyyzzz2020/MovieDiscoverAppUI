//
//  DiscoverView.swift
//  MovieDiscoverAppUI
//
//  Created by yongzhan on 2020/6/20.
//  Copyright © 2020 yongzhan. All rights reserved.
//

import SwiftUI

struct DiscoverView: View {
    var movies = Movie.stubbedMovies
    var currentMovie: Movie? = Movie.stubbedMovies.last
    
    var body: some View {
        ZStack {
            self.renderCards()
            GeometryReader { gr in
                Text("Movie Discover")
                    .foregroundColor(Color.white)
                    .titleFont(size: 16)
                    .position(x: gr.frame(in: .local).midX,
                              y: gr.frame(in: .local).minY + 50)
                
                self.renderButtons()
                    .position(x: gr.frame(in: .local).midX,
                              y: gr.frame(in: .local).maxY - 50)
            }
        }
        .background(FullBackgroundView(imageLoader: ImageLoaderCache.shared.loadedFor(with: currentMovie!.poster_path, size: .medium)))
    }
    
    
    func renderCards() -> some View {
        
        ZStack {
            ForEach (self.movies) { movie in
                DiscoverImage(imageLoader: ImageLoaderCache.shared.loadedFor(with: movie.poster_path, size: .medium))
                    .scaleEffect(1 - CGFloat(self.movies.reversed().firstIndex(where: { $0.id == movie.id})! ) * 0.03 )
                    .padding(.bottom, CGFloat(self.movies.reversed().firstIndex(where: { $0.id == movie.id})! ) * 16 )
            
            }
        }
        
    }
    
    func renderButtons() -> some View {
        
        ZStack {
            if currentMovie != nil {
                Text(currentMovie!.title)
                    .foregroundColor(Color.white)
                    .titleFont(size: 30)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .offset(x: 0, y: -60)
                    .opacity(1)
                
                
                Circle()
                    .strokeBorder(Color.red,lineWidth: 1)
                    .frame(width: 50, height: 50)
                    .overlay(Image(systemName: "xmark").foregroundColor(Color.red))
                
     
                Circle()
                    .strokeBorder(Color.pink,lineWidth: 1)
                    
                    .frame(width: 50, height: 50)
                    .overlay(Image(systemName: "heart.fill").foregroundColor(Color.pink))
                    .offset(x: -60, y: -30)
                    .opacity(0)
                
                Circle()
                    .strokeBorder(Color.green,lineWidth: 1)
                    .frame(width: 50, height: 50)
                    .overlay(Image(systemName: "eye.fill").foregroundColor(Color.green))
                    .offset(x: 60, y: -30)
                    .opacity(0)
                
                
                Button(action: {
                    
                }) {
                    Image(systemName: "gobackward")
                }
                .frame(width: 40, height: 40)
                .offset(x: -60, y: 0)
                .foregroundColor(Color.purple)
                .opacity(1)
                
                Button(action: {
                    
                }) {
                    Image(systemName: "arrow.swap")
                }
                .frame(width: 40, height: 40)
                .offset(x: 60, y: 0)
                .foregroundColor(Color.purple)
                .opacity(1)
            }
        }
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
