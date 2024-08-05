//
//  EpisodesCoordinator.swift
//  Rick&Morty
//
//  Created by Kostya Lee on 28/07/24.
//

import Foundation
import UIKit

protocol EpisodesCoordinatorDelegate: CoordinatorDelegate {
    func navigateToFavorites()
    func navigateToDetails(_ characterID: String)
}

class EpisodesCoordinator: Coordinator {
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    private let diContainer: DIContainer
    
    init(navigationController: UINavigationController, diContainer: DIContainer) {
        self.navigationController = navigationController
        self.diContainer = diContainer
    }
    
    func start() {
        showEpisodes()
    }
    
    func showEpisodes() {
        let episodesViewController = EpisodesAssembly.build(with: diContainer)
        if let vc = episodesViewController as? EpisodesViewController {
            vc.provideNavigationDelegate(self)
        }
        episodesViewController.tabBarItem = UITabBarItem(title: "Episodes", image: UIImage(systemName: "house"), tag: 0)
//        navigationController.pushViewController(episodesViewController, animated: true)
        navigationController.viewControllers = [episodesViewController]
    }
}

extension EpisodesCoordinator: EpisodesCoordinatorDelegate {
    func navigateToFavorites() {
        let favoritesViewController = FavoritesAssembly.build(with: diContainer)
        navigationController.pushViewController(favoritesViewController, animated: true)
    }
    
    func navigateToDetails(_ characterUrl: String) {
        let detailsController = CharacterDetailsAssembly.build(with: diContainer, characterUrl: characterUrl)
        navigationController.pushViewController(detailsController, animated: true)
    }
}
