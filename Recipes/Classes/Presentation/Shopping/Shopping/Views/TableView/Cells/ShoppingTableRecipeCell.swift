//
//  ShoppingTableRecipeCell.swift
//  Recipes
//
//  Created by Андрей Чернышев on 26.10.2022.
//

import UIKit
import Kingfisher

final class ShoppingTableRecipeCell: UITableViewCell {
    var menuTapped: (() -> Void)?
    
    lazy var container = makeContainer()
    lazy var recipeImageView = makeImageView()
    lazy var nameLabel = makeLabel()
    lazy var countLabel = makeLabel()
    lazy var menuButton = makeMenuButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        
        recipeImageView.kf.cancelDownloadTask()
        recipeImageView.image = nil
    }
}

// MARK: Public
extension ShoppingTableRecipeCell {
    func setup(element: Shopping) {
        recipeImageView.kf.setImage(with: element.recipe.imageUrl)
        
        let nameAttrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.semiBold(size: 16.scale))
            .lineHeight(20.8.scale)
            .letterSpacing(-0.17.scale)
            .textAlignment(.left)
            .lineBreakMode(.byTruncatingTail)
        nameLabel.attributedText = element.recipe.name.attributed(with: nameAttrs)
        
        let countAttrs = TextAttributes()
            .textColor(Appearance.black.withAlphaComponent(0.5))
            .font(Fonts.PlusJakartaSans.regular(size: 16.scale))
            .lineHeight(24.scale)
            .letterSpacing(-0.17.scale)
            .textAlignment(.left)
            .lineBreakMode(.byTruncatingTail)
        let count = String(format: "Shopping.IngredientsCount".localized, element.ingredients.count)
        countLabel.attributedText = count.attributed(with: countAttrs)
    }
}

// MARK: Private
private extension ShoppingTableRecipeCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    @objc
    func didTappedMenu() {
        menuTapped?()
    }
}

// MARK: Make constraints
private extension ShoppingTableRecipeCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            recipeImageView.widthAnchor.constraint(equalToConstant: 80.scale),
            recipeImageView.heightAnchor.constraint(equalToConstant: 65.scale),
            recipeImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12.scale),
            recipeImageView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 102.scale),
            nameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -47.scale),
            nameLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            countLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 102.scale),
            countLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -47.scale),
            countLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 46.scale)
        ])
        
        NSLayoutConstraint.activate([
            menuButton.widthAnchor.constraint(equalToConstant: 24.scale),
            menuButton.heightAnchor.constraint(equalToConstant: 24.scale),
            menuButton.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            menuButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ShoppingTableRecipeCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.white
        view.layer.cornerRadius = 16.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.backgroundColor = Appearance.secondary5
        view.layer.borderColor = UIColor(integralRed: 239, green: 234, blue: 220).cgColor
        view.layer.borderWidth = 1.scale
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeMenuButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Shopping.Menu"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(didTappedMenu), for: .touchUpInside)
        container.addSubview(view)
        return view
    }
}
