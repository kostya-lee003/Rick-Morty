//
//  FavoritesViewModel.swift
//  Rick&Morty
//
//  Created by Kostya Lee on 28/07/24.
//

import Foundation

class FavoritesViewModel {
    private let repository: FavoritesRepository
    var navigationDelegate: FavoritesCoordinatorDelegate?
    
    @Published var items: [Episode] = []
    
    init(repository: FavoritesRepository) {
        self.repository = repository
    }
    
    func getFavorites() {
        self.items = repository.getFavorites()
    }
    
    func saveEpisodesToRepository() {
        repository.save(items)
    }
    
    func removeFromFavorites(index: Int) {
        if let indexToRemove = items.firstIndex(where: { $0 == items[index] }) {
            items.remove(at: indexToRemove)
        }
    }
}
