//
//  RecipeIngredientCell.swift
//  Recipes
//
//  Created by Андрей Чернышев on 11.10.2022.
//

import UIKit

final class RecipeIngredientCell: UITableViewCell {
    lazy var checkedView = makeCheckedView()
    lazy var titleLabel = makeTitleLabel()
    
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
extension RecipeIngredientCell {
    func setup(element: RecipeTableIngredientElement) {
        checkedView.image = UIImage(named: element.marked ? "Recipe.Checkbox.Check" : "Recipe.Checkbox.Uncheck")
        
        let titleAttrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.bold(size: 16.scale))
            .lineHeight(19.2.scale)
            .letterSpacing(-0.17.scale)
        titleLabel.attributedText = element.ingredient.name.attributed(with: titleAttrs)
    }
}

// MARK: Private
private extension RecipeIngredientCell {
    func initialize() {
        backgroundColor = Appearance.background
        contentView.backgroundColor = Appearance.background
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension RecipeIngredientCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            checkedView.widthAnchor.constraint(equalToConstant: 24.scale),
            checkedView.heightAnchor.constraint(equalToConstant: 24.scale),
            checkedView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            checkedView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2.5.scale),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2.5.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension RecipeIngredientCell {
    func makeCheckedView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
        view.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 0), for: .horizontal)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
