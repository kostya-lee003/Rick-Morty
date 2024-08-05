//
//  CacheModels.swift
//  Rick&Morty
//
//  Created by Kostya Lee on 05/08/24.
//

import Foundation

final class CachedEpisodes {
    let episodes: [Episode]
    
    init(episodes: [Episode]) {
        self.episodes = episodes
    }
    
    init() {
        self.episodes = []
    }
}
