//
//  ChallengeBadgeImageView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 18.08.2022.
//

import UIKit

final class ChallengeBadgeImageView: UIView {
    lazy var originalView = makeImageView()
    lazy var darkenImageView = makeDarkenView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 98.scale, height: 98.scale)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let view = UIImageView()
        view.image = UIImage(named: "Challenge.Badges.Mask")
        view.frame = bounds

        originalView.mask = view
    }
}

// MARK: Public
extension ChallengeBadgeImageView {
    func setup(image: String, progress: Int) {
        originalView.image = UIImage(named: String(format: "%@.Original", image))
        
        let darkenHeight = intrinsicContentSize.height - (intrinsicContentSize.height / 100) * CGFloat(progress)
        darkenImageView.image = UIImage(named: String(format: "%@.Darken", image))
        darkenImageView.frame.origin = CGPoint.zero
        darkenImageView.frame.size = CGSize(width: intrinsicContentSize.width, height: darkenHeight)
    }
}

// MARK: Make constraints
private extension ChallengeBadgeImageView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            originalView.leadingAnchor.constraint(equalTo: leadingAnchor),
            originalView.trailingAnchor.constraint(equalTo: trailingAnchor),
            originalView.topAnchor.constraint(equalTo: topAnchor),
            originalView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ChallengeBadgeImageView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.contentMode = .top
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeDarkenView() -> UIImageView {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.contentMode = .top
        addSubview(view)
        return view
    }
}
