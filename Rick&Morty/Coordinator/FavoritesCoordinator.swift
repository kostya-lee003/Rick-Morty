//
//  FavoritesCoordinator.swift
//  Rick&Morty
//
//  Created by Kostya Lee on 02/08/24.
//

import Foundation
import UIKit

protocol FavoritesCoordinatorDelegate: CoordinatorDelegate {
    func navigateToDetails(_ characterID: String)
}

class FavoritesCoordinator: Coordinator {
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    private let diContainer: DIContainer

    init(navigationController: UINavigationController, diContainer: DIContainer) {
        self.navigationController = navigationController
        self.diContainer = diContainer
    }
    
    func start() {
        let favoritesViewController = FavoritesAssembly.build(with: diContainer)
        if let vc = favoritesViewController as? FavoritesViewController {
            vc.provideNavigationDelegate(self)
        }
        favoritesViewController.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart"), tag: 1)
//        navigationController.pushViewController(favoritesViewController, animated: true)
        navigationController.viewControllers = [favoritesViewController]
    }
}

extension FavoritesCoordinator: FavoritesCoordinatorDelegate {
    func navigateToDetails(_ characterUrl: String) {
        let detailsController = CharacterDetailsAssembly.build(with: diContainer, characterUrl: characterUrl)
        navigationController.pushViewController(detailsController, animated: true)
    }
}
