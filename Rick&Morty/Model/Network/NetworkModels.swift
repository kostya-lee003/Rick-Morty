//
//  Models.swift
//  Rick&Morty
//

import Foundation

/// For diffable data source inside EpisodesViewController
enum Section {
    case main
}

struct Episode: Codable, Equatable, Hashable {
    let id: Int
    let name: String
    let air_date: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
    
    static func == (lhs: Episode, rhs: Episode) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.name == rhs.name
    }
}

struct EpisodesInfo: Decodable {
    let count: Int
    let pages: Int
    let next: String
    let prev: String?
}

struct Episodes: Decodable {
    let info: EpisodesInfo
    let results: [Episode]
}

class Character: Decodable {
//    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: CharacterOrigin
//    let location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
    
    enum CodingKeys: String, CodingKey {
//        case id
        case name
        case status
        case species
        case type
        case gender
        case origin
//        case location
        case image
        case episode
        case url
        case created
    }
}

struct Location: Decodable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    let url: String
    let created: String
}

struct CharacterOrigin: Decodable {
    let name: String
    let url: String
}
