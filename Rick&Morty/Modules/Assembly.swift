//
//  Assembly.swift
//  Rick&Morty
//

import Foundation
import UIKit

final class EpisodesAssembly {
    static func build(with dependencies: DIContainer) -> UIViewController {
        return dependencies.moduleFactory.makeEpisodesModule()
    }
}

final class CharacterDetailsAssembly {
    static func build(with dependencies: DIContainer, characterUrl: String) -> UIViewController {
        return dependencies.moduleFactory.makeCharacterDetailsModule(characterUrl: characterUrl)
    }
}

final class FavoritesAssembly {
    static func build(with dependencies: DIContainer) -> UIViewController {
        return dependencies.moduleFactory.makeFavoritesModule()
    }
}

