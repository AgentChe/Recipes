//
//  ChallengeBadgeView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 17.08.2022.
//

import UIKit

final class ChallengeBadgeView: UIView {
    lazy var progressLabel = makeProgressLabel()
    lazy var imageView = makeImageView()
    lazy var nameLabel = makeNameLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ChallengeBadgeView {
    func setup(image: String, name: String, progress: Int, hiddenTextProgress: Bool) {
        imageView.setup(image: image, progress: progress)
        
        progressLabel.label.attributedText = String(format: "%i%%", progress)
            .attributed(with: TextAttributes()
                            .textColor(Appearance.white)
                            .font(Fonts.PlusJakartaSans.bold(size: 14.scale))
                            .lineHeight(16.8.scale)
                            .textAlignment(.center))
        progressLabel.isHidden = hiddenTextProgress
        
        nameLabel.attributedText = name
            .attributed(with: TextAttributes()
                            .textColor(Appearance.black)
                            .font(Fonts.PlusJakartaSans.regular(size: 16.scale))
                            .lineHeight(24.scale)
                            .letterSpacing(-0.17.scale)
                            .textAlignment(.center))
    }
}

// MARK: Make constraints
private extension ChallengeBadgeView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 2.scale)
        ])
        
        NSLayoutConstraint.activate([
            progressLabel.widthAnchor.constraint(equalToConstant: 49.scale),
            progressLabel.heightAnchor.constraint(equalToConstant: 24.scale),
            progressLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8.scale),
            progressLabel.topAnchor.constraint(equalTo: topAnchor, constant: 2.scale)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 110.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ChallengeBadgeView {
    func makeProgressLabel() -> ChallengeBadgeProgressLabel {
        let view = ChallengeBadgeProgressLabel()
        view.backgroundColor = Appearance.secondary1
        view.layer.cornerRadius = 12.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> ChallengeBadgeImageView {
        let view = ChallengeBadgeImageView()
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeNameLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
