//
//  RecipeShoppingButtonCell.swift
//  Recipes
//
//  Created by Андрей Чернышев on 11.10.2022.
//

import UIKit

final class RecipeShoppingButtonCell: UITableViewCell {
    lazy var button = makeButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 35.scale),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -35.scale),
            button.topAnchor.constraint(equalTo: contentView.topAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension RecipeShoppingButtonCell {
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.semiBold(size: 16.scale))
            .letterSpacing(-0.17.scale)
        
        let view = UIButton()
        view.setAttributedTitle("Recipe.Shopping.AddAll".localized.attributed(with: attrs), for: .normal)
        view.layer.cornerRadius = 16.scale
        view.backgroundColor = Appearance.secondary5
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
