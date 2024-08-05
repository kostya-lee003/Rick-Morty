//
//  AppCoordinator.swift
//  Rick&Morty
//

import Foundation
import UIKit

protocol Coordinator {
    var children: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start()
}

protocol CoordinatorDelegate: AnyObject {}

class AppCoordinator: NSObject, Coordinator {
    var navigationController: UINavigationController
    
    var children: [Coordinator] = []
    private let diContainer: DIContainer
    var window: UIWindow?
    
    var tabBarController: UITabBarController
    var episodesCoordinator: EpisodesCoordinator
    var favoritesCoordinator: FavoritesCoordinator

    init(diContainer: DIContainer, navigationController: UINavigationController, window: UIWindow?) {
        self.diContainer = diContainer
        self.navigationController = navigationController
        self.window = window
        
        self.tabBarController = UITabBarController()

        let episodesNavController = UINavigationController()
        self.episodesCoordinator = EpisodesCoordinator(navigationController: episodesNavController, diContainer: diContainer)

        let favoritesNavController = UINavigationController()
        self.favoritesCoordinator = FavoritesCoordinator(navigationController: favoritesNavController, diContainer: diContainer)

        self.tabBarController.viewControllers = [episodesNavController, favoritesNavController]
        
        super.init()
        tabBarController.delegate = self
    }

    func start() {
        
        window?.rootViewController = LaunchScreenViewController()
        window?.makeKeyAndVisible()
        
        // Через несколько секунд перейдите на основной экран
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let self, let window else { return }
            episodesCoordinator.start()
            favoritesCoordinator.start()
//            window?.rootViewController = tabBarController
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: { [weak self] in
                guard let self else { return }
                window.rootViewController = tabBarController
            }, completion: nil)
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        
        return true
    }
}

extension AppCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        viewController.viewWillAppear(true)
    }
}
