//
//  EpisodesCollectionCell.swift
//  Rick&Morty
//

import Foundation
import UIKit

class EpisodesCollectionCell: UICollectionViewCell {
    public static var id = "EpisodesCollectionCell"
    private let decoder = JSONDecoder()
    
    var touchViewSelected: (() -> Void)?
    var favoriteButtonSelected: ((Bool) -> Void)?
    
    private let background: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.shadowRadius = 3
        return view
    }()
    
    private let backgroundTouchView = UIButton()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let bottomBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.3)
        return view
    }()
    
    private let episodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "play.tv")
        imageView.tintColor = .black
        return imageView
    }()
    
    private let episodeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .label.withAlphaComponent(0.8)
        return label
    }()
    
    private let favoriteButton: HeartButton = {
        let button = HeartButton()
        button.tintColor = .red
        button.imageView!.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
          button.imageView!.widthAnchor.constraint(equalTo: button.widthAnchor, multiplier: 1),
          button.imageView!.heightAnchor.constraint(equalTo: button.heightAnchor, multiplier: 1),
          button.imageView!.centerXAnchor.constraint(equalTo: button.centerXAnchor),
          button.imageView!.centerYAnchor.constraint(equalTo: button.centerYAnchor),
        ])
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(background)
        contentView.addSubview(imageView)
        contentView.addSubview(bottomBackground)
        contentView.addSubview(titleLabel)
        contentView.addSubview(episodeImageView)
        contentView.addSubview(episodeTitleLabel)
        contentView.addSubview(backgroundTouchView)
        contentView.addSubview(favoriteButton)
        self.layout()
        backgroundTouchView.addTarget(self, action: #selector(backgroundViewTapped), for: .touchUpInside)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped(_:)), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func layout() {
        // Setup all views with autolayout
        imageView.translatesAutoresizingMaskIntoConstraints = false
        bottomBackground.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        episodeImageView.translatesAutoresizingMaskIntoConstraints = false
        episodeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        let offset = 12.0
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 1),
            imageView.heightAnchor.constraint(equalToConstant: 280),
            imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            
            bottomBackground.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 1),
            bottomBackground.heightAnchor.constraint(equalToConstant: 70),
            bottomBackground.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            bottomBackground.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomBackground.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: offset),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -offset),
            
            episodeImageView.centerYAnchor.constraint(equalTo: bottomBackground.centerYAnchor),
            episodeImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: offset),
            episodeImageView.widthAnchor.constraint(equalToConstant: 30),
            episodeImageView.heightAnchor.constraint(equalToConstant: 30),
            
            favoriteButton.centerYAnchor.constraint(equalTo: bottomBackground.centerYAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 35),
            favoriteButton.heightAnchor.constraint(equalToConstant: 35),
            favoriteButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -offset),
            
            episodeTitleLabel.centerYAnchor.constraint(equalTo: bottomBackground.centerYAnchor),
            episodeTitleLabel.leftAnchor.constraint(equalTo: episodeImageView.rightAnchor, constant: offset),
            episodeTitleLabel.rightAnchor.constraint(equalTo: favoriteButton.leftAnchor, constant: -offset)
        ])
        background.frame = contentView.bounds
        backgroundTouchView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        imageView.image = nil
        imageView.cancelImageLoad()
        favoriteButton.clear()
    }
    
    @objc func backgroundViewTapped() {
        self.touchViewSelected?()
    }
    
    @objc func favoriteButtonTapped(_ sender: UIButton) {
        if let sender = sender as? HeartButton {
            sender.flipLikedState()
            self.favoriteButtonSelected?(sender.isLiked)
        }
    }
}

extension EpisodesCollectionCell {
    func update(_ item: Episode) {
        requestCharacter(item.characters.last ?? "") { [weak self] character in
            guard let self else { return }
            DispatchQueue.main.async {
                self.titleLabel.text = character.name
            }
            guard let url = URL(string: character.image) else { return }
            self.imageView.loadImage(at: url)
        }
        episodeTitleLabel.text = "\(item.name) | \(item.episode)"
    }
    
    func highlightFavorite() {
        self.favoriteButton.makeLiked()
    }
    
    func clearFavorite() {
        self.favoriteButton.clear()
    }
    
    private func requestCharacter(_ url: String?, _ completion: @escaping (Character) -> Void) {
        guard let url = URL(string: url ?? "") else { return }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request, completionHandler: { [weak self] data, _, error in
            guard let self, let data, error == nil else {
                return
            }
            do {
                let decodedData = try self.decoder.decode(Character.self, from: data)
                completion(decodedData)
            } catch let DecodingError.dataCorrupted(context) {
                print(context)
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print("error: ", error)
            }
        }).resume()
    }
}
