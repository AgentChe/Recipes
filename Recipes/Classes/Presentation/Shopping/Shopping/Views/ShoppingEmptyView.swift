//
//  ShoppingEmptyView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 14.10.2022.
//

import UIKit

final class ShoppingEmptyView: UIView {
    enum State {
        case allIngredients, byRecipe
    }
    
    lazy var imageView = makeImageView()
    lazy var titleLabel = makeLabel()
    lazy var subTitleLabel = makeLabel()
    lazy var button = makeButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ShoppingEmptyView {
    func update(at state: State) {
        let titleAttrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.bold(size: 19.scale))
            .lineHeight(26.6.scale)
            .letterSpacing(-0.44.scale)
            .textAlignment(.center)
        
        let subTitleAttrs = TextAttributes()
            .textColor(Appearance.black.withAlphaComponent(0.5))
            .font(Fonts.PlusJakartaSans.regular(size: 16.scale))
            .lineHeight(24.scale)
            .letterSpacing(-0.17.scale)
            .textAlignment(.center)
        
        switch state {
        case .allIngredients:
            imageView.image = UIImage(named: "Shopping.Empty.AllIngredients")
            titleLabel.attributedText = "Shopping.Empty.AllIngredients.Title".localized.attributed(with: titleAttrs)
            subTitleLabel.attributedText = "Shopping.Empty.AllIngredients.SubTitle".localized.attributed(with: subTitleAttrs)
        case .byRecipe:
            imageView.image = UIImage(named: "Shopping.Empty.ByRecipe")
            titleLabel.attributedText = "Shopping.Empty.ByRecipe.Title".localized.attributed(with: titleAttrs)
            subTitleLabel.attributedText = "Shopping.Empty.ByRecipe.SubTitle".localized.attributed(with: subTitleAttrs)
        }
    }
}

// MARK: Make constraints
private extension ShoppingEmptyView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 106.scale),
            imageView.heightAnchor.constraint(equalToConstant: 122.scale),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: subTitleLabel.topAnchor, constant: -8.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            subTitleLabel.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -28.scale)
        ])
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 166.scale),
            button.heightAnchor.constraint(equalToConstant: 49.scale),
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ShoppingEmptyView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.semiBold(size: 16.scale))
            .letterSpacing(-0.17.scale)
        
        let view = UIButton()
        view.backgroundColor = Appearance.primaryYellow
        view.layer.cornerRadius = 16.scale
        view.setAttributedTitle("Shopping.Empty.Button".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
