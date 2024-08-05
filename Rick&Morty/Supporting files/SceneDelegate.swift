//
//  SceneDelegate.swift
//  Rick&Morty
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    private let diContainer = DIContainer()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        configureScene(windowScene)
    }
    
    private func configureScene(_ windowScene: UIWindowScene) {
        let navController = UINavigationController()
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        appCoordinator = AppCoordinator(diContainer: diContainer, navigationController: navController, window: window)
        appCoordinator?.start()
    }

}

