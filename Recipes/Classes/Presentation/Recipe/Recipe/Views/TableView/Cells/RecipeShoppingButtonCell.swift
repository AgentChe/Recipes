//
//  RecipeShoppingButtonCell.swift
//  Recipes
//
//  Created by Андрей Чернышев on 11.10.2022.
//

import UIKit

final class RecipeShoppingButtonCell: UITableViewCell {
    lazy var container = makeContainer()
    lazy var label = makeLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension RecipeShoppingButtonCell {
    func setup(element: RecipeIngredientsShell) {
        let title = element.allSelected ? "Recipe.Shopping.RemoveAll".localized : "Recipe.Shopping.AddAll".localized
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.semiBold(size: 16.scale))
            .lineHeight(20.8.scale)
            .letterSpacing(-0.17.scale)
            .textAlignment(.center)
        label.attributedText = title.attributed(with: attrs)
    }
}

// MARK: Private
private extension RecipeShoppingButtonCell {
    func initialize() {
        backgroundColor = Appearance.background
        contentView.backgroundColor = Appearance.background
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension RecipeShoppingButtonCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 35.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -35.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension RecipeShoppingButtonCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 16.scale
        view.backgroundColor = Appearance.secondary5
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
