//
//  CharacterDetailsCell.swift
//  Rick&Morty
//
//  Created by Kostya Lee on 01/08/24.
//

import Foundation
import UIKit
class CharacterDetailsCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    func update(title: String?, subtitle: String?) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        self.contentView.addSubview(titleLabel)
        
        subtitleLabel.font = .systemFont(ofSize: 16)
        subtitleLabel.textColor = .darkGray
        self.contentView.addSubview(subtitleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12),
            titleLabel.heightAnchor.constraint(equalToConstant: titleLabel.font.pointSize + 3),
            
            subtitleLabel.topAnchor.constraint(equalTo: contentView.centerYAnchor),
            subtitleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12),
            subtitleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12),
            subtitleLabel.heightAnchor.constraint(equalToConstant: subtitleLabel.font.pointSize + 3)
        ])
    }
}
