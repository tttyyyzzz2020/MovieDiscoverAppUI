//
//  ImageLoader.swift
//  MovieDiscoverAppUI
//
//  Created by yongzhan on 2020/6/20.
//  Copyright © 2020 yongzhan. All rights reserved.
//

import Foundation
import Combine
import UIKit
import SwiftUI

class ImageLoaderCache {
    static let shared = ImageLoaderCache()
    var loaders: NSCache<NSString, ImageLoader>  = NSCache<NSString, ImageLoader>()
    
    func loadedFor(with name: String, size: ImageService.Size) -> ImageLoader {
        let key = NSString(string: "\(name)#\(size.path(with: name))")
        if let loader = self.loaders.object(forKey: key) {
            return loader
        } else {
            let loader = ImageLoader(with: name, size: size)
            loaders.setObject(loader, forKey: key)
            return loader
        }
    }
}


class ImageLoader: ObservableObject {
    let path : String?
    let size: ImageService.Size
    
    
    @Published var image: UIImage?
    var objectWillChange: AnyPublisher<UIImage?, Never> = Publishers.Sequence<[UIImage?], Never>(sequence: []).eraseToAnyPublisher()
    var cancelable: AnyCancellable?
    
    init(with name: String? , size: ImageService.Size = .medium) {
        self.path = name
        self.size = size
        
        objectWillChange = $image.handleEvents(receiveSubscription: { [weak self](sub) in
            self?.loadImage()
            }, receiveCancel: {
                self.cancelable?.cancel()
        })
        .eraseToAnyPublisher()
    }
    
    func loadImage(){
        guard let path = path, image == nil else { return }
        self.cancelable = ImageService.shared.fetchImage(with: path, size: size)
            .receive(on: DispatchQueue.main)
            .assign(to: \ImageLoader.image, on: self)
    }
    
    deinit {
        self.cancelable?.cancel()
    }
    
}
