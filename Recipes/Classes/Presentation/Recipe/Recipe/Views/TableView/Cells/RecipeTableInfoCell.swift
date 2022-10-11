//
//  RecipeTableInfoCell.swift
//  Recipes
//
//  Created by Андрей Чернышев on 11.10.2022.
//

import UIKit

final class RecipeTableInfoCell: UITableViewCell {
    lazy var container = makeContainer()
    lazy var nameLabel = makeLabel()
    lazy var categoriesLabel = makeLabel()
    
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
extension RecipeTableInfoCell {
    func setup(element: RecipeTableInfoElement) {
        let nameAttrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.bold(size: 28.scale))
            .lineHeight(36.4.scale)
            .letterSpacing(-0.37.scale)
            .textAlignment(.center)
            .lineBreakMode(.byTruncatingTail)
        nameLabel.attributedText = element.name.attributed(with: nameAttrs)
        
        let categoriesAttrs = TextAttributes()
            .textColor(Appearance.black.withAlphaComponent(0.5))
            .font(Fonts.PlusJakartaSans.regular(size: 16.scale))
            .lineHeight(24.scale)
            .letterSpacing(-0.17.scale)
            .textAlignment(.center)
            .lineBreakMode(.byTruncatingTail)
        let categories = element.categories.joined(separator: ",")
        categoriesLabel.attributedText = categories.attributed(with: categoriesAttrs)
    }
}

// MARK: Private
private extension RecipeTableInfoCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension RecipeTableInfoCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 32.scale),
            nameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -32.scale),
            nameLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 30.scale)
        ])
        
        NSLayoutConstraint.activate([
            categoriesLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 32.scale),
            categoriesLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -32.scale),
            categoriesLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5.scale),
            categoriesLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension RecipeTableInfoCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.background
        view.layer.cornerRadius = 40.scale
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
