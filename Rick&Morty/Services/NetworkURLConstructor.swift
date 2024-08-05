//
//  NetworkURLConstructor.swift
//  Rick&Morty
//
//  Created by Kostya Lee on 29/07/24.
//

import Foundation
struct URLConstructor {
    private let base = "https://rickandmortyapi.com/api"
    
    enum Endpoint {
        case episodes
        case character(id: String)
    }
    
    func constructURL(for endpoint: Endpoint) -> URL? {
        switch endpoint {
        case .episodes:
            return URL(string: "\(base)/episode")
        case .character(let id):
            return URL(string: "\(base)/character/\(id)")
        }
    }
}
