//
//  FavoritesViewController.swift
//  Rick&Morty
//

import Foundation
import UIKit
import Combine

class FavoritesViewController: UIViewController {

    private var cancellables: Set<AnyCancellable> = []
    
    private var viewModel: FavoritesViewModel
    
    func provideNavigationDelegate(_ delegate: FavoritesCoordinatorDelegate) {
        self.viewModel.navigationDelegate = delegate
    }
    
    private var collectionViewLayout: UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 50
        layout.minimumInteritemSpacing = 50
        layout.itemSize = CGSize(width: self.view.frame.width * 0.9, height: self.view.frame.width)
        return layout
    }
    
    private lazy var collectionView = UICollectionView(
        frame: view.bounds,
        collectionViewLayout: collectionViewLayout
    )
    
    private func bindToVM() {
        viewModel.$items
            .receive(on: RunLoop.main)
            .sink { [weak self] (items) in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        self.title = "Favorites"
        view.backgroundColor = .white
        bindToVM()
        setupCollection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getFavorites()
        collectionView.reloadData() /// Since The change of Published value not triggering sink{}, I manually reload collection
    }
    
    private func setupCollection() {
        collectionView.register(EpisodesCollectionCell.self, forCellWithReuseIdentifier: EpisodesCollectionCell.id)
        collectionView.dataSource = self
        collectionView.delegate = self
        self.view.addSubview(collectionView)
    }
}

extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EpisodesCollectionCell.id, for: indexPath) as? EpisodesCollectionCell {
            let item = viewModel.items[indexPath.row]
            print("Favorite: \(item.id)")
            cell.update(item)
            cell.touchViewSelected = { [weak self] in
                self?.viewModel.navigationDelegate?.navigateToDetails(item.characters.last ?? "")
            }
            cell.favoriteButtonSelected = { [weak self] _ in
                self?.viewModel.removeFromFavorites(index: indexPath.row)
                self?.viewModel.saveEpisodesToRepository()
                collectionView.reloadSections([0]) // calling reload bc of index out of range bug
            }
            cell.highlightFavorite()
            return cell
        }
        return UICollectionViewCell()
    }
}
