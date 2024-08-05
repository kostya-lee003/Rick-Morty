//
//  EpisodesViewModel.swift
//  Rick&Morty
//
//  Created by Kostya Lee on 25/07/24.
//

import Foundation
import UIKit
import Combine

class EpisodesViewModel {
    private let networkService: NetworkServiceProtocol
    private let favoritesRepository: FavoritesRepository
    var navigationDelegate: EpisodesCoordinatorDelegate?
    
    var originItems: [Episode] = []
    @Published var items: [Episode] = []
    @Published private(set) var favoriteItems: [Episode] = []
    @Published var searchText = ""

    init(networkService: NetworkServiceProtocol, favoritesRepository: FavoritesRepository) {
        self.networkService = networkService
        self.favoritesRepository = favoritesRepository
    }
    
    func requestEpisodes() {
        networkService.fetchEpisodes() { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                self.originItems = success.results
                self.items = success.results
            case .failure(let failure):
                NSLog(.commonLogFormat, failure.localizedDescription)
            }
        }
    }
    
    func updateFavoriteItems() {
        self.favoriteItems = favoritesRepository.getFavorites()
    }
    
    func addToFavorites(index: Int) {
        favoriteItems.append(items[index])
    }
    
    func removeFromFavorites(index: Int) {
        if let indexToRemove = favoriteItems.firstIndex(where: { $0 == items[index] }) {
            favoriteItems.remove(at: indexToRemove)
        }
    }
    
    func saveEpisodesToRepository() {
        favoritesRepository.save(favoriteItems)
    }
}
