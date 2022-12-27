//
//  RecipeView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 11.07.2022.
//

import UIKit

final class RecipeView: UIView {
    lazy var imageView = makeImageView()
    lazy var tableView = makeTableView()
    lazy var navView = makeNavView()
    lazy var closeButton = makeCloseButton()
    lazy var shareButton = makeShareButton()
    lazy var favoriteButton = makeFavoriteButton()
    lazy var bottomView = makeBottomView()
    lazy var stepButton = makeStepButton()
    lazy var preloader = makePreloader()
    
    private lazy var navViewHeightConstraint = NSLayoutConstraint()
    
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
extension RecipeView {
    func update(tableContentOffset: CGFloat) {
        let maxHeight = ScreenSize.isIphoneXFamily ? 99.scale : 79.scale
        let offsetHeight = max(0, tableContentOffset / 2)
        let height = min(maxHeight, offsetHeight)
        
        navViewHeightConstraint.isActive = false
        navViewHeightConstraint.constant = height
        navViewHeightConstraint.isActive = true
        
        layoutIfNeeded()
    }
}

// MARK: Private
private extension RecipeView {
    func initialize() {
        backgroundColor = Appearance.background
    }
}

// MARK: Make constraints
private extension RecipeView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 434.scale : 374.scale)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor)
        ])
        
        navViewHeightConstraint = navView.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            navView.leadingAnchor.constraint(equalTo: leadingAnchor),
            navView.trailingAnchor.constraint(equalTo: trailingAnchor),
            navView.topAnchor.constraint(equalTo: topAnchor),
            navViewHeightConstraint
        ])
        
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 41.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 41.scale),
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6.scale),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 52.scale : 32.scale)
        ])
        
        NSLayoutConstraint.activate([
            shareButton.widthAnchor.constraint(equalToConstant: 41.scale),
            shareButton.heightAnchor.constraint(equalToConstant: 41.scale),
            shareButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 265.scale),
            shareButton.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            favoriteButton.widthAnchor.constraint(equalToConstant: 41.scale),
            favoriteButton.heightAnchor.constraint(equalToConstant: 41.scale),
            favoriteButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 318.scale),
            favoriteButton.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 139.scale : 99.scale)
        ])
        
        NSLayoutConstraint.activate([
            stepButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16.scale),
            stepButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16.scale),
            stepButton.heightAnchor.constraint(equalToConstant: 49.scale),
            stepButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 30.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloader.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension RecipeView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTableView() -> RecipeTableView {
        let view = RecipeTableView()
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeNavView() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.background
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func makeCloseButton() -> RecipeNavButton {
        let view = RecipeNavButton()
        view.backgroundColor = Appearance.secondary5
        view.iconView.image = UIImage(named: "Recipe.Close")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeShareButton() -> RecipeNavButton {
        let view = RecipeNavButton()
        view.backgroundColor = Appearance.secondary5
        view.iconView.image = UIImage(named: "Recipe.Share")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeFavoriteButton() -> RecipeNavButton {
        let view = RecipeNavButton()
        view.backgroundColor = Appearance.secondary5
        view.iconView.image = UIImage(named: "Recipe.Mark.Uncheck")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeBottomView() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.background
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.06
        view.layer.shadowOffset = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeStepButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.semiBold(size: 16.scale))
            .letterSpacing(-0.17.scale)
        
        let view = UIButton()
        view.setAttributedTitle("Recipe.StepButton".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.primaryYellow
        view.layer.cornerRadius = 16.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        bottomView.addSubview(view)
        return view
    }
    
    func makePreloader() -> Spinner {
        let view = Spinner(size: CGSize(width: 45.scale, height: 45.scale))
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
