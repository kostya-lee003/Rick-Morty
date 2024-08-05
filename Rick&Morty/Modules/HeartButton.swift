//
//  HeartButton.swift
//  Rick&Morty
//
//  Created by Kostya Lee on 28/07/24.
//

import UIKit

public class HeartButton: UIButton {
    private(set) var isLiked = false

    private var unlikedImage: UIImage? = UIImage(systemName: "heart")
    private var likedImage: UIImage? = UIImage(systemName: "heart.fill")

    private let unlikedScale: CGFloat = 0.7
    private let likedScale: CGFloat = 1.3
    
    var isTintColorWhite = false {
        didSet {
            if isTintColorWhite {
                unlikedImage = UIImage(systemName: "heart")?.withTintColor(.white)
                self.setImage(unlikedImage, for: .normal)
            }
        }
    }
    
    private let generator = UIImpactFeedbackGenerator(style: .medium)

    override public init(frame: CGRect) {
        super.init(frame: frame)

        setImage(unlikedImage, for: .normal)
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func deinitValues() {
        unlikedImage = nil
        likedImage = nil
        imageView?.image = nil
    }

    public func flipLikedState() {
        isLiked = !isLiked
        vibrate()
        animate()
    }
    
    public func makeLiked() {
        isLiked = true
        let newImage = self.likedImage
        self.setImage(newImage, for: .normal)
    }
    
    public func clear() {
        isLiked = false
        self.setImage(unlikedImage, for: .normal)
    }

    private func animate() {
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            let newImage = self?.isLiked ?? false ? self?.likedImage : self?.unlikedImage
            let newScale = self?.isLiked ?? false ? self?.likedScale ?? 1.3 : self?.unlikedScale ?? 0.7
            self?.transform = self?.transform.scaledBy(x: newScale, y: newScale) ?? .init()
            self?.setImage(newImage, for: .normal)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: { [weak self] in
                self?.transform = CGAffineTransform.identity
            })
        })
    }

    private func vibrate() {
        generator.impactOccurred()
    }
}

