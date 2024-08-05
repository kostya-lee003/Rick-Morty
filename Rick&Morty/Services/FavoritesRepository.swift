//
//  FavoritesRepository.swift
//  Rick&Morty
//

import Foundation

struct FavoritesRepository {
    func getFavorites() -> [Episode] {
        UserDefaults.standard.load(forKey: UserDefaults.UserDefaultsKeys.savedEpisodes.rawValue, as: [Episode].self) ?? []
    }
    
    func save(_ episodes: [Episode]) {
        let userDefaults = UserDefaults.standard
        let key = UserDefaults.UserDefaultsKeys.savedEpisodes.rawValue
        
        userDefaults.save(objects: episodes, forKey: key)
        
//        print(episodes.map({ $0.id }))
    }
    
    func saveOne(_ newEpisode: Episode) {
        let userDefaults = UserDefaults.standard
        let key = UserDefaults.UserDefaultsKeys.savedEpisodes.rawValue
        
        var episodes = userDefaults.load(forKey: key, as: [Episode].self) ?? []
        episodes.append(newEpisode)
        userDefaults.save(objects: episodes, forKey: key)
        
//        print(episodes.map({ $0.id }))
    }

    
    func removeOne(_ episodeToRemove: Episode) {
        let userDefaults = UserDefaults.standard
        let key = UserDefaults.UserDefaultsKeys.savedEpisodes.rawValue
        
        var episodes = userDefaults.load(forKey: key, as: [Episode].self) ?? []
        if let index = episodes.firstIndex(where: { $0 == episodeToRemove }) {
            episodes.remove(at: index)
            userDefaults.save(objects: episodes, forKey: key)
        }
        
//        print(episodes.map({ $0.id }))
    }
}
