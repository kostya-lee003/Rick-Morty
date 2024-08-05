//
//  LaunchScreenViewController.swift
//  Rick&Morty
//
//  Created by Kostya Lee on 05/08/24.
//

import Foundation
import UIKit

class LaunchScreenViewController: UIViewController {
    
    private let logoImageView = UIImageView()
    private let portalImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        setupViews()
    }
    
    func setupViews() {
        self.view.backgroundColor = .white
        logoImageView.image = UIImage(named: "logo")
        logoImageView.contentMode = .scaleAspectFit
        self.view.addSubview(logoImageView)
        
        if let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "portal", withExtension: "gif")!) {
            portalImageView.image = UIImage.gifImageWithData(imageData)
        }
        portalImageView.contentMode = .scaleAspectFit
        self.view.addSubview(portalImageView)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        portalImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            logoImageView.heightAnchor.constraint(equalToConstant: 150),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
        
            portalImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            portalImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            portalImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            portalImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
