//
//  RRecipesTableRecipeCell.swift
//  Recipes
//
//  Created by Андрей Чернышев on 19.07.2022.
//

import UIKit
import Kingfisher

final class RRecipesTableRecipeCell: UITableViewCell {
    lazy var numberLabel = makeLabel()
    lazy var recipeImageView = makeImageView()
    lazy var nameLabel = makeLabel()
    lazy var timeIconView = makeTimeIconView()
    lazy var timeLabel = makeLabel()
    
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
extension RRecipesTableRecipeCell {
    func setup(element: RRecipesTableRecipeElement) {
        recipeImageView.kf.setImage(with: element.recipe.imageUrl)
        
        numberLabel.attributedText = element.number
            .attributed(with: TextAttributes()
                            .textColor(Appearance.black)
                            .font(Fonts.PlusJakartaSans.bold(size: 20.scale))
                            .lineHeight(24.scale)
                            .letterSpacing(-0.17.scale))
        
        nameLabel.attributedText = element.recipe.name
            .attributed(with: TextAttributes()
                            .textColor(Appearance.black)
                            .font(Fonts.PlusJakartaSans.semiBold(size: 16.scale))
                            .lineHeight(20.8.scale)
                            .letterSpacing(-0.17.scale)
                            .lineBreakMode(.byTruncatingTail))
        
        let time = String(format: "Ranking.Time".localized, element.recipe.time)
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
private extension RRecipesTableRecipeCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension RRecipesTableRecipeCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            numberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24.scale),
            numberLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            recipeImageView.widthAnchor.constraint(equalToConstant: 80.scale),
            recipeImageView.heightAnchor.constraint(equalToConstant: 65.scale),
            recipeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 53.scale),
            recipeImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 143.scale),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7.5.scale)
        ])
        
        NSLayoutConstraint.activate([
            timeIconView.widthAnchor.constraint(equalToConstant: 24.scale),
            timeIconView.heightAnchor.constraint(equalToConstant: 24.scale),
            timeIconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 143.scale),
            timeIconView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5.scale)
        ])
        
        NSLayoutConstraint.activate([
            timeLabel.leadingAnchor.constraint(equalTo: timeIconView.trailingAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: timeIconView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension RRecipesTableRecipeCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTimeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Ranking.Time")
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
