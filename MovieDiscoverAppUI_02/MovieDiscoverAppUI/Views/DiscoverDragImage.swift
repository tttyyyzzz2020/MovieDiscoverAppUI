//
//  DiscoverDragImage.swift
//  MovieDiscoverAppUI
//
//  Created by yongzhan on 2020/6/20.
//  Copyright © 2020 yongzhan. All rights reserved.
//

import SwiftUI

struct DiscoverDragImage: View {
    var movie: Movie
    @Binding var gestureDragState: DragState
    var onTapGesutre: () -> Void
    var willEndGesutre: (CGSize) -> Void
    var endGesutreHandler: (EndState)-> Void

    
    enum DragState {
        // 手势的状态
        case inactive
        case pressing
        case dragging( translation: CGSize, predictedEndLocation: CGPoint)
        
        // 移动的距离
        var translation: CGSize {
            switch self {
            case .inactive, .pressing:
                return .zero
            case .dragging(let translation, _):
                return translation
            }
        }
        
        // 移动终点位置
        var predictedEndLocation: CGPoint {
            switch self {
            case .inactive, .pressing:
                return .zero
            case .dragging(_, let predictedEndLocation):
                return predictedEndLocation
            }
        }
        
        // 活动状态
        var isActive: Bool {
            switch self {
            case .inactive:
                return false
            default:
                return true
            }
        }
        
        // 拖动状态
        var isDragging: Bool {
            switch self {
            case .inactive, .pressing:
                return false
            default:
                return true
            }
        }
        
    }
    
    enum EndState {
        case left, right, cancel
    }
    
    
    @GestureState var dragState: DragState = .inactive
    @State private var hasMoved = false
    @State private var predictedEndLocation: CGPoint? = nil
    
    var body: some View {
        let LongPressDragGesture = LongPressGesture(minimumDuration: 0.0)
            .sequenced(before: DragGesture())
            .updating($dragState) { (value, state,transaction) in
                switch value {
                case .first(true):
                    state = .pressing
                     self.feedBack.prepare()
                case .second(true, let drag):
                    state = .dragging(translation: drag?.translation ?? .zero, predictedEndLocation: drag?.predictedEndLocation ?? .zero)
                default:
                    state = .inactive
                }
        }
        .onChanged { (value) in
            if self.dragState.translation.width == 0.0 {
                self.gestureDragState = .pressing
                self.hasMoved = false
            } else {
                self.gestureDragState = .dragging(translation: self.dragState.translation, predictedEndLocation: self.dragState.predictedEndLocation)
                self.hasMoved = true
            }
        }
        .onEnded { (value) in
            let endLocation = self.gestureDragState.predictedEndLocation
            
            if endLocation.x < -150 {
                self.willEndGesutre(self.dragState.translation)
                self.predictedEndLocation = endLocation
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.endGesutreHandler(.left)
                }
            } else if endLocation.x > UIScreen.main.bounds.width - 50 {
                self.willEndGesutre(self.dragState.translation)
                self.predictedEndLocation = endLocation
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.endGesutreHandler(.right)
                }
            } else {
                self.endGesutreHandler(.cancel)
            }
            self.gestureDragState = .inactive
        }
        
       
        return DiscoverImage(imageLoader: ImageLoaderCache.shared.loadedFor(with: movie.poster_path, size: .medium))
            .offset(self.computedOffset())
            .scaleEffect(self.dragState.isActive ? 1.03 : 1)
            .rotationEffect(self.computedAngle())
            .opacity(self.predictedEndLocation != nil ? 0 : 1)
            .shadow(color: Color.secondary,
                    radius: self.dragState.isActive ?  16 : 0,
                    x: self.dragState.isActive ?  4 : 0,
                    y: self.dragState.isActive ?  4 : 0)
            .animation(.interpolatingSpring(mass: 1, stiffness: 150, damping: 15, initialVelocity: 5))
            .gesture(LongPressDragGesture)
            .simultaneousGesture(TapGesture(count: 1).onEnded({ (_) in
                if !self.hasMoved {
                    self.onTapGesutre()
                }
            }))
            .onTapGesture {
                self.feedBack.prepare()
        }
        
        
    }
    
    let feedBack = UISelectionFeedbackGenerator()
    
    // 计算角度
    func computedAngle() -> Angle {
        if let endLocation = self.predictedEndLocation {
            return Angle(degrees: Double(endLocation.x / 15))
        }
        return Angle(degrees: Double(self.dragState.isDragging ? self.dragState.translation.width / 15 : 0))
    }
    
    // 计算偏移
    func computedOffset() -> CGSize {
        if let endLocation = self.predictedEndLocation {
            return CGSize(width: endLocation.x, height: 0)
        }
        return CGSize(width: self.dragState.isDragging ? self.dragState.translation.width : 0 , height: 0)
        
    }
    
}

struct DiscoverDragImage_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverDragImage(movie: Movie.stubbedMovies.last!,
                          gestureDragState: .constant(.inactive),
                          onTapGesutre: {},
                          willEndGesutre: {_ in},
                          endGesutreHandler: { _ in}
        )
    }
}
