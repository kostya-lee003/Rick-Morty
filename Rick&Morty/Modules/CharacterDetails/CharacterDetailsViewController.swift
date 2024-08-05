//
//  CharacterDetailsViewController.swift
//  Rick&Morty
//

import Foundation
import UIKit
import Combine

class CharacterDetailsViewController: UIViewController {
    
    struct ListItem {
        var title: String
        var subtitle: String
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    private var viewModel: CharacterDetailsViewModel {
        didSet {
            self.bindToVM()
        }
    }
    
    private let cellIdentifier = "cell"
    
    private var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private var infoTableView = UITableView()
    
    private func bindToVM() {
        viewModel.$items
            .sink { [weak self] (items) in
                guard !items.isEmpty,
                      let self else { return }
                self.infoTableView.reloadData()
            }.store(in: &cancellables)
        
        viewModel.$model
            .sink { [weak self] model in
                guard let model else { return }
                self?.updateUI(with: model)
            }
            .store(in: &cancellables)
    }
    
    func updateUI(with model: Character) {
        if let url = URL(string: model.image) {
            self.avatarImageView.loadImage(at: url)
        }
        self.nameLabel.text = model.name
        viewModel.items = [
            ListItem(title: "Gender", subtitle: model.gender),
            ListItem(title: "Status", subtitle: model.status),
            ListItem(title: "Specie", subtitle: model.species),
            ListItem(title: "Origin", subtitle: model.origin.name),
            ListItem(title: "Type", subtitle: model.type),
            ListItem(title: "Location", subtitle: model.origin.url),
        ]
        infoTableView.reloadData()
    }
        
    init(viewModel: CharacterDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.bindToVM()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        layout()
        viewModel.requestCharacter()
    }
    
    private func setupViews() {
        self.view.backgroundColor = .white
        self.view.addSubview(avatarImageView)
        self.view.addSubview(nameLabel)
        setupTableView()
    }
    
    private func setupTableView() {
        infoTableView.delegate = self
        infoTableView.dataSource = self
        infoTableView.register(CharacterDetailsCell.self, forCellReuseIdentifier: cellIdentifier)
        self.view.addSubview(infoTableView)
    }
    
    private func layout() {
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        infoTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 150),
            avatarImageView.heightAnchor.constraint(equalToConstant: 150),
            avatarImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            avatarImageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 150),
            
            nameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            
            infoTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            infoTableView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            infoTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            infoTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        avatarImageView.layer.cornerRadius = 75
        avatarImageView.layer.masksToBounds = true
    }
}

extension CharacterDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CharacterDetailsCell {
            let item = viewModel.items[indexPath.row]
            cell.update(title: item.title, subtitle: item.subtitle)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Informations"
    }
}

