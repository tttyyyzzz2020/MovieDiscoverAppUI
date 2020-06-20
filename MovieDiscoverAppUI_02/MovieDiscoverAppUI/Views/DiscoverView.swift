//
//  DiscoverView.swift
//  MovieDiscoverAppUI
//
//  Created by yongzhan on 2020/6/20.
//  Copyright © 2020 yongzhan. All rights reserved.
//

import SwiftUI

struct DiscoverView: View {
    @State var movies = Movie.stubbedMovies
    @State var currentMovie: Movie? = Movie.stubbedMovies.last
    @State var gestureDragState = DiscoverDragImage.DragState.inactive
    
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
                
                if self.movies.reversed().firstIndex(where: { $0.id == movie.id})! == 0 {
                    DiscoverDragImage(movie: movie,
                                      gestureDragState: self.$gestureDragState,
                                      onTapGesutre: {
                                        
                    }, willEndGesutre: { (postion) in
                        
                    }) { (direction) in
                        self.endGestureHandler(direction: direction)
                    }
                } else {
                    
                    DiscoverImage(imageLoader: ImageLoaderCache.shared.loadedFor(with: movie.poster_path, size: .medium))
                        .scaleEffect(1 - CGFloat(self.movies.reversed().firstIndex(where: { $0.id == movie.id})! ) * 0.03 + self.computedScale() )
                        .padding(.bottom, CGFloat(self.movies.reversed().firstIndex(where: { $0.id == movie.id})! ) * 16 )
                        .animation(.spring())
                }
                
            }
        }
        
    }
    
    func computedScale() -> CGFloat {
        CGFloat(abs(gestureDragState.translation.width /  6000))
    }
    
    func leftZone() -> Double {
        Double(-gestureDragState.translation.width / 1000)
    }
    
    func rightZone() -> Double {
        Double(gestureDragState.translation.width / 1000)
    }
    
    func endGestureHandler(direction: DiscoverDragImage.EndState) {
        if direction == .left || direction == .right {
            _ = self.movies.popLast()
            
            if self.movies.count < 5 {
                let moviesIds = self.movies.map{ $0.id }
                let newMovies = Movie.stubbedMovies.filter{ !moviesIds.contains($0.id) }
                self.movies.append(contentsOf: newMovies)
                self.currentMovie = self.movies.last
            } else {
                self.currentMovie = self.movies.last
                self.feedBack.impactOccurred(intensity: 0.8)
            }
            
        }
    }
    
    
    let feedBack = UIImpactFeedbackGenerator()
    
    func renderButtons() -> some View {
        ZStack {
            if currentMovie != nil {
                Text(currentMovie!.title)
                    .foregroundColor(Color.white)
                    .titleFont(size: 30)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .offset(x: 0, y: -60)
                    .opacity(gestureDragState.isDragging ? 0 : 1)
                    .animation(.easeInOut)
                
                
                Circle()
                    .strokeBorder(Color.red,lineWidth: 1)
                    .frame(width: 50, height: 50)
                    .overlay(Image(systemName: "xmark").foregroundColor(Color.red))
                    .opacity(gestureDragState.isDragging ? 0 : 1)
                    .animation(.easeInOut)
                    .onTapGesture {
                       _ =  self.movies.popLast()
                        self.currentMovie = self.movies.last
                }
                
                
                Circle()
                    .strokeBorder(Color.pink,lineWidth: 1)
                    
                    .frame(width: 50, height: 50)
                    .overlay(Image(systemName: "heart.fill").foregroundColor(Color.pink))
                    .offset(x: -60, y: -30)
                    .opacity(gestureDragState.isDragging ? 0.5 + self.leftZone() : 0)
                    .animation(.easeInOut)
                
                Circle()
                    .strokeBorder(Color.green,lineWidth: 1)
                    .frame(width: 50, height: 50)
                    .overlay(Image(systemName: "eye.fill").foregroundColor(Color.green))
                    .offset(x: 60, y: -30)
                    .opacity(gestureDragState.isDragging ?  0.5 + self.rightZone() : 0)
                    .animation(.easeInOut)
                
                
                Button(action: {
                    self.movies = Movie.stubbedMovies
                    self.currentMovie = self.movies.last
                }) {
                    Image(systemName: "gobackward")
                }
                .frame(width: 40, height: 40)
                .offset(x: -60, y: 0)
                .foregroundColor(Color.purple)
                .opacity(gestureDragState.isDragging ? 0 : 1)
                .animation(.easeInOut)
                
                Button(action: {
                    self.movies = self.movies.shuffled()
                    self.currentMovie = self.movies.last
                }) {
                    Image(systemName: "arrow.swap")
                }
                .frame(width: 40, height: 40)
                .offset(x: 60, y: 0)
                .foregroundColor(Color.purple)
                .opacity(gestureDragState.isDragging ? 0 : 1)
                .animation(.easeInOut)
            }
        }
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
