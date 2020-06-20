//
//  ImageService.swift
//  MovieDiscoverAppUI
//
//  Created by yongzhan on 2020/6/20.
//  Copyright © 2020 yongzhan. All rights reserved.
//

import Foundation
import Combine
import UIKit
import SwiftUI

// https://image.tmdb.org/t/p/w500/5KCVkau1HEl7ZzfPsKAPM0sMiKc.jpg
class ImageService {
    static let shared = ImageService()
    static let baseURL = "https://image.tmdb.org/t/p/"
    
    enum Size:String {
        case small = "w154"
        case medium = "w500"
        
        func path(with name: String, size: ImageService.Size = .medium) -> URL {
            return URL(string: "\(baseURL)\(size.rawValue)\(name)")!
        }
    }
    
    // 获取图片数据
    func fetchImage(with name: String , size: ImageService.Size) -> AnyPublisher<UIImage?, Never> {
        URLSession.shared.dataTaskPublisher(for: size.path(with: name, size: size))
            .tryMap { (data, response) -> UIImage? in
                return UIImage(data: data)!
        }
        .catch { (error) in
            Just(nil)
        }
        .eraseToAnyPublisher()
    }
}
