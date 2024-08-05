//
//  DIContainer.swift
//  Rick&Morty
//

import Foundation

final class DIContainer {
    lazy var moduleFactory: ModuleFactory = ModuleFactory(self)
    lazy var networkService: NetworkServiceProtocol = NetworkService()
    lazy var favoritesRepository = FavoritesRepository()
}
