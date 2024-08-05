//
//  UserDefaultsExtension.swift
//  Rick&Morty
//
//  Created by Kostya Lee on 31/07/24.
//

import Foundation
extension UserDefaults {
    enum UserDefaultsKeys: String {
        case savedEpisodes = "saved_episodes"
    }
    
    func save<T: Codable>(objects: [T], forKey key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(objects) {
            self.set(encoded, forKey: key)
        }
    }
    
    func load<T: Codable>(forKey key: String, as type: [T].Type) -> [T]? {
        if let savedData = self.data(forKey: key) {
            let decoder = JSONDecoder()
            if let loadedObjects = try? decoder.decode(type, from: savedData) {
                return loadedObjects
            }
        }
        return nil
    }
}
