//
//  LBMButton.swift
//  Recipes
//
//  Created by Андрей Чернышев on 22.07.2022.
//

import UIKit

final class LBMButton: UIButton {
    lazy var imageContainer = makeImageContainer()
    lazy var iconView = makeImageView()
    lazy var label = makeLabel()
    
    private let title: String
    private let imageName: String
    
    init(title: String, imageName: String) {
        self.title = title
        self.imageName = imageName
        
        super.init(frame: .zero)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 343.scale, height: 41.scale)
    }
}

// MARK: Make constraints
private extension LBMButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageContainer.widthAnchor.constraint(equalToConstant: 41.scale),
            imageContainer.heightAnchor.constraint(equalToConstant: 41.scale),
            imageContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageContainer.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 22.scale),
            iconView.heightAnchor.constraint(equalToConstant: 22.scale),
            iconView.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 51.scale),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension LBMButton {
    func makeImageContainer() -> CircleView {
        let view = CircleView()
        view.backgroundColor = Appearance.secondary5
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: imageName)
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.semiBold(size: 16.scale))
            .lineHeight(20.8.scale)
            .letterSpacing(-0.17.scale)
        
        let view = UILabel()
        view.attributedText = title.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
