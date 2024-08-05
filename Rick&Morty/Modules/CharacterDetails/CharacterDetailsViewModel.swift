//
//  CharacterDetailsViewModel.swift
//  Rick&Morty
//
//  Created by Kostya Lee on 25/07/24.
//

import Foundation
import UIKit
import Combine

class CharacterDetailsViewModel {
    private let networkService: NetworkServiceProtocol
    
    @Published var items: [CharacterDetailsViewController.ListItem] = []
    
//    let model = PassthroughSubject<Character, Never>()
    
    @Published var model: Character?
    
    private var modelUrl: String?
    
    init(networkService: NetworkServiceProtocol, modelUrl: String) {
        self.networkService = networkService
        self.modelUrl = modelUrl
    }
    
    func requestCharacter() {
        guard let modelUrl else { return }
        networkService.requestCharacter(id: modelUrl) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    self.model = success
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}
