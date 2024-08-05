//
//  ModuleFactory.swift
//  Rick&Morty
//
import Foundation
import UIKit

final class ModuleFactory {
    private let diContainer: DIContainer
    
    init(_ diContainer: DIContainer) {
        self.diContainer = diContainer
    }
    
    func makeEpisodesModule() -> UIViewController {
        let viewModel = EpisodesViewModel(networkService: diContainer.networkService, favoritesRepository: diContainer.favoritesRepository)
        let viewController = EpisodesViewController(viewModel: viewModel)
        return viewController
    }
    
    func makeCharacterDetailsModule(characterUrl: String) -> UIViewController {
        let service = diContainer.networkService
        let viewModel = CharacterDetailsViewModel(networkService: service, modelUrl: characterUrl)
        let viewController = CharacterDetailsViewController(viewModel: viewModel)
        return viewController
    }
    
    func makeFavoritesModule() -> UIViewController {
        let repository = diContainer.favoritesRepository
        let viewModel = FavoritesViewModel(repository: repository)
        let viewController = FavoritesViewController(viewModel: viewModel)
        return viewController
    }
}
