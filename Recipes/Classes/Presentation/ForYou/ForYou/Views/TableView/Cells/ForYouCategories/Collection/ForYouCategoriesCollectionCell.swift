//
//  ForYouCategoriesCollectionCell.swift
//  Recipes
//
//  Created by Андрей Чернышев on 07.07.2022.
//

import UIKit

final class ForYouCategoriesCollectionCell: UICollectionViewCell {
    lazy var container = makeContainer()
    lazy var nameLabel = makeLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ForYouCategoriesCollectionCell {
    static func width(for element: Category) -> CGFloat {
        let attrs = TextAttributes()
            .font(Fonts.PlusJakartaSans.semiBold(size: 16.scale))
            .lineHeight(20.8.scale)
            .letterSpacing(-0.17.scale)
        let size = element.name.attributed(with: attrs).size()
        return size.width + 32.scale
    }
    
    func setup(element: Category) {
        nameLabel.attributedText = element.name
            .attributed(with: TextAttributes()
                            .textColor(Appearance.black)
                            .font(Fonts.PlusJakartaSans.semiBold(size: 16.scale))
                            .lineHeight(20.8.scale)
                            .letterSpacing(-0.17.scale))
    }
}

// MARK: Private
private extension ForYouCategoriesCollectionCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension ForYouCategoriesCollectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            nameLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ForYouCategoriesCollectionCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.secondary5
        view.layer.cornerRadius = 16.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
