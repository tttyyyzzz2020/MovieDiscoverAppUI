//
//  Movie.swift
//  MovieDiscoverAppUI
//
//  Created by yongzhan on 2020/6/20.
//  Copyright © 2020 yongzhan. All rights reserved.
//

import Foundation

struct Movie: Identifiable, Decodable {
    var id: Int
    var title: String
    var poster_path: String
    
    static var stubbedMovies: [Movie] {
        let url = Bundle.main.url(forResource: "discover_movie", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let games = try! JSONDecoder().decode([Movie].self, from: data)
        return games
    }
}
