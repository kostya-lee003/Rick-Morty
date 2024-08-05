////
////  CachingService.swift
////  Rick&Morty
////
////  Created by Kostya Lee on 03/08/24.
////
//
//import Foundation
//
//class EpisodeCachingService {
//    let cache = NSCache<NSString, CachedEpisodes>()
//    let key = NSString(string: String(describing: CachedEpisodes.self))
//    
//    func cache(_ items: CachedEpisodes) {
//        let myObject: CachedEpisodes
//
//        if let cachedVersion = cache.object(forKey: key) {
//            // use the cached version
//            myObject = cachedVersion
//        } else {
//            // create it from scratch then store in the cache
//            myObject = CachedEpisodes()
//        }
//        cache.setObject(myObject, forKey: key)
//    }
//    
//    func get() -> CachedEpisodes? {
//        return cache.object(forKey: key)
//    }
//}
