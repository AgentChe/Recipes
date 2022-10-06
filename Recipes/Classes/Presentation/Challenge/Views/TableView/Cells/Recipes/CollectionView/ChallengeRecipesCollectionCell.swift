//
//  ChallengeRecipesCollectionCell.swift
//  Recipes
//
//  Created by Андрей Чернышев on 17.08.2022.
//

import UIKit
import Kingfisher

final class ChallengeRecipesCollectionCell: UICollectionViewCell {
    lazy var container = makeContainer()
    lazy var checkedView = makeCheckedView()
    lazy var dayNumberLabel = makeLabel()
    lazy var recipeNameLabel = makeLabel()
    lazy var timeIconView = makeTimeIconView()
    lazy var timeLabel = makeLabel()
    lazy var recipeImageView = makeRecipeImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
extension ChallengeRecipesCollectionCell {
    func setup(element: ChallengeRecipeElement) {
        let recipe = element.recipe
        
        recipeImageView.kf.setImage(with: recipe.imageUrl)
        
        checkedView.image = UIImage(named: element.completed ? "Challenge.Checked" : "Challenge.Unchecked")
        
        container.layer.borderWidth = element.current ? 3.scale : 0
        container.layer.borderColor = element.current ? Appearance.secondary2.withAlphaComponent(0.3).cgColor : UIColor.clear.cgColor
        
        let day = String(format: "Challenge.Day".localized, element.dayNumber)
        dayNumberLabel.attributedText = day
            .attributed(with: TextAttributes()
                            .textColor(Appearance.black)
                            .font(Fonts.PlusJakartaSans.bold(size: 20.scale))
                            .lineHeight(24.scale)
                            .letterSpacing(-0.17.scale))
        
        recipeNameLabel.attributedText = recipe.name
            .attributed(with: TextAttributes()
                            .textColor(Appearance.black)
                            .font(Fonts.PlusJakartaSans.semiBold(size: 16.scale))
                            .lineHeight(20.8.scale)
                            .letterSpacing(-0.17.scale)
                            .lineBreakMode(.byTruncatingTail))
        
        let time = String(format: "Challenge.Time".localized, element.recipe.time)
        timeLabel.attributedText = time
            .attributed(with: TextAttributes()
                            .textColor(Appearance.black.withAlphaComponent(0.5))
                            .font(Fonts.PlusJakartaSans.regular(size: 16.scale))
                            .lineHeight(24.scale)
                            .letterSpacing(-0.17.scale)
                            .lineBreakMode(.byTruncatingTail))
    }
}

// MARK: Private
private extension ChallengeRecipesCollectionCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension ChallengeRecipesCollectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            checkedView.widthAnchor.constraint(equalToConstant: 32.scale),
            checkedView.heightAnchor.constraint(equalToConstant: 32.scale),
            checkedView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20.scale),
            checkedView.topAnchor.constraint(equalTo: container.topAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            dayNumberLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20.scale),
            dayNumberLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 59.scale)
        ])
        
        NSLayoutConstraint.activate([
            recipeNameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20.scale),
            recipeNameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -164.scale),
            recipeNameLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 100.scale)
        ])
        
        NSLayoutConstraint.activate([
            timeIconView.widthAnchor.constraint(equalToConstant: 24.scale),
            timeIconView.heightAnchor.constraint(equalToConstant: 24.scale),
            timeIconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.scale),
            timeIconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 145.scale)
        ])
        
        NSLayoutConstraint.activate([
            timeLabel.leadingAnchor.constraint(equalTo: timeIconView.trailingAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: timeIconView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            recipeImageView.widthAnchor.constraint(equalToConstant: 151.scale),
            recipeImageView.heightAnchor.constraint(equalToConstant: 124.scale),
            recipeImageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 15.scale),
            recipeImageView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -15.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ChallengeRecipesCollectionCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 20.scale
        view.backgroundColor = Appearance.white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.03
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 6.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeCheckedView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
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
    
    func makeRecipeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeTimeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Challenge.Time")
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
