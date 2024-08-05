//
//  ViewController.swift
//  Rick&Morty
//

import UIKit
import Combine

class EpisodesViewController: UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Episode>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Episode>
    
    private var cancellables = Set<AnyCancellable>()
    
    private var viewModel: EpisodesViewModel
    
    func provideNavigationDelegate(_ delegate: EpisodesCoordinatorDelegate) {
        self.viewModel.navigationDelegate = delegate
    }

    private let searchController = UISearchController()
    
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
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Episode>?
    
    init(viewModel: EpisodesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        view.backgroundColor = .white
        self.title = "Rick & Morty"
        bindViewModel()
        setupSearch()
        setupCollection()
        viewModel.requestEpisodes()
        setupDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.updateFavoriteItems()
        collectionView.reloadData() /// Since method reloadData does not clear all favorite items, I manually reload collection
    }
    
    private func bindViewModel() {
        viewModel.$items
            .receive(on: RunLoop.main)
            .sink { [weak self] (items) in
                guard let self else { return }
                self.reloadData() // reload data does not reload collection...
//                self.collectionView.reloadData()
            }.store(in: &cancellables)
        
        viewModel.$favoriteItems
            .receive(on: RunLoop.main)
            .sink { [weak self] (favItems) in
                self?.viewModel.saveEpisodesToRepository()
            }.store(in: &cancellables)
        
        viewModel.$searchText
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                guard let self else { return }
                print(text)
                if text.replacingOccurrences(of: " ", with: "").isEmpty {
                    self.viewModel.items = self.viewModel.originItems
                } else {
                    // Sort originItems into items according to text
                    self.viewModel.items = self.viewModel.originItems.filter({ episode in
                        return episode.name.contains(text) || episode.episode.contains(text)
                    })
                }
            }
            .store(in: &cancellables)
        
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: searchController.searchBar.searchTextField)
            .map { ($0.object as? UITextField)?.text ?? "" }
            .assign(to: \.searchText, on: viewModel)
            .store(in: &cancellables)
    }
    
    private func setupSearch() {
        searchController.searchBar.delegate = self
        searchController.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupCollection() {
        collectionView.register(EpisodesCollectionCell.self, forCellWithReuseIdentifier: EpisodesCollectionCell.id)
        self.view.addSubview(collectionView)
    }
    
    private func setupDataSource() {
        dataSource = DataSource(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, episode in
            guard let self else { return UICollectionViewCell() }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EpisodesCollectionCell.id, for: indexPath) as? EpisodesCollectionCell
            let item = viewModel.items[indexPath.row]
            cell?.update(item)
            cell?.touchViewSelected = { [weak self] in
                self?.viewModel.navigationDelegate?.navigateToDetails(item.characters.last ?? "")
            }
            cell?.favoriteButtonSelected = { [weak self] isLiked in
                if isLiked {
                    self?.viewModel.addToFavorites(index: indexPath.row)
                } else {
                    self?.viewModel.removeFromFavorites(index: indexPath.row)
                }
                self?.viewModel.saveEpisodesToRepository()
            }
            if viewModel.favoriteItems.contains(item) {
                cell?.highlightFavorite()
            } else {
                cell?.clearFavorite()
            }
            return cell
        })
        collectionView.dataSource = dataSource
    }
    
    private func reloadData() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.items)
        dataSource?.apply(snapshot)
    }
}

extension EpisodesViewController: UISearchControllerDelegate, UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchText = ""
    }
}
