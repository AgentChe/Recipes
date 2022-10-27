//
//  ShoppingTableIngredientCell.swift
//  Recipes
//
//  Created by Андрей Чернышев on 26.10.2022.
//

import UIKit

final class ShoppingTableIngredientCell: UITableViewCell {
    var removeTapped: (() -> Void)?
    
    lazy var checkedView = makeCheckedView()
    lazy var titleLabel = makeTitleLabel()
    lazy var valueLabel = makeValueLabel()
    lazy var buttonContainer = makeButtonContainer()
    lazy var buttonIconView = makeButtonIconView()
    lazy var separator = makeSeparator()
    
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
extension ShoppingTableIngredientCell {
    func setup(element: ShoppingTableIngredientElement) {
        let ingredient = element.ingredient
        
        let marked = element.shopping.markedIngredients.contains(where: { $0.id == ingredient.id })
        checkedView.image = UIImage(named: marked ? "Shopping.Checkbox.Check" : "Shopping.Checkbox.Uncheck")
        
        let titleAttrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.bold(size: 16.scale))
            .lineHeight(19.2.scale)
            .letterSpacing(-0.17.scale)
        titleLabel.attributedText = ingredient.name.attributed(with: titleAttrs)
        
        let valueAttrs = TextAttributes()
            .textColor(Appearance.black.withAlphaComponent(0.5))
            .font(Fonts.PlusJakartaSans.regular(size: 16.scale))
            .lineHeight(24.scale)
            .letterSpacing(-0.17.scale)
        valueLabel.attributedText = ingredient.value.attributed(with: valueAttrs)
    }
}

// MARK: Private
private extension ShoppingTableIngredientCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    @objc
    func didTappedRemove() {
        removeTapped?()
    }
}

// MARK: Make constraints
private extension ShoppingTableIngredientCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            checkedView.widthAnchor.constraint(equalToConstant: 24.scale),
            checkedView.heightAnchor.constraint(equalToConstant: 24.scale),
            checkedView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            checkedView.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50.scale),
            titleLabel.trailingAnchor.constraint(equalTo: valueLabel.leadingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2.5.scale)
        ])
        
        NSLayoutConstraint.activate([
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            valueLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            buttonContainer.widthAnchor.constraint(equalToConstant: 36.scale),
            buttonContainer.heightAnchor.constraint(equalToConstant: 32.scale),
            buttonContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            buttonContainer.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            buttonIconView.widthAnchor.constraint(equalToConstant: 20.scale),
            buttonIconView.heightAnchor.constraint(equalToConstant: 20.scale),
            buttonIconView.centerXAnchor.constraint(equalTo: buttonContainer.centerXAnchor),
            buttonIconView.centerYAnchor.constraint(equalTo: buttonContainer.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            separator.heightAnchor.constraint(equalToConstant: 1.scale),
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ShoppingTableIngredientCell {
    func makeCheckedView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
        view.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 0), for: .horizontal)
        view.numberOfLines = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeValueLabel() -> UILabel {
        let view = UILabel()
        view.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        view.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeButtonContainer() -> TapAreaButton {
        let view = TapAreaButton()
        view.layer.cornerRadius = 7.scale
        view.backgroundColor = Appearance.secondary5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(didTappedRemove), for: .touchUpInside)
        contentView.addSubview(view)
        return view
    }
    
    func makeButtonIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.image = UIImage(named: "Shopping.Delete")
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.secondary5
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
