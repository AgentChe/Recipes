//
//  CategoryCollectionCell.swift
//  Recipes
//
//  Created by Андрей Чернышев on 11.07.2022.
//

import UIKit
import Kingfisher

final class CategoryCollectionCell: UICollectionViewCell {
    lazy var recipeImageView = makeImageView()
    lazy var nameLabel = makeLabel(numberOfLines: 2)
    lazy var timeIconView = makeTimeIconView()
    lazy var timeLabel = makeLabel(numberOfLines: 1)
    lazy var undeterminedTimeLabel = makeUndeterminedTimeLabel()
    
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
extension CategoryCollectionCell {
    func setup(element: RecipeCover) {
        recipeImageView.kf.setImage(with: element.imageUrl)
        
        nameLabel.attributedText = element.name
            .attributed(with: TextAttributes()
                            .textColor(Appearance.black)
                            .font(Fonts.PlusJakartaSans.semiBold(size: 16.scale))
                            .lineHeight(20.8.scale)
                            .letterSpacing(-0.17.scale)
                            .lineBreakMode(.byTruncatingTail))
        
        let totalTime = (element.timePreparing ?? 0) + (element.timeCooking ?? 0)
        
        timeIconView.isHidden = totalTime == 0
        timeLabel.isHidden = totalTime == 0
        undeterminedTimeLabel.isHidden = totalTime != 0
        
        let time = String(format: "Category.Time".localized, totalTime)
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
private extension CategoryCollectionCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension CategoryCollectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            recipeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            recipeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            recipeImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            recipeImageView.heightAnchor.constraint(equalToConstant: 134.scale)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameLabel.topAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            timeIconView.widthAnchor.constraint(equalToConstant: 24.scale),
            timeIconView.heightAnchor.constraint(equalToConstant: 24.scale),
            timeIconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            timeIconView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5.scale)
        ])
        
        NSLayoutConstraint.activate([
            timeLabel.leadingAnchor.constraint(equalTo: timeIconView.trailingAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: timeIconView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            undeterminedTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            undeterminedTimeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CategoryCollectionCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel(numberOfLines: Int) -> UILabel {
        let view = UILabel()
        view.numberOfLines = numberOfLines
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeTimeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Category.Time")
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeUndeterminedTimeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.black.withAlphaComponent(0.5))
            .font(Fonts.PlusJakartaSans.regular(size: 16.scale))
            .lineHeight(24.scale)
            .letterSpacing(-0.17.scale)
            .lineBreakMode(.byTruncatingTail)
        
        let view = UILabel()
        view.attributedText = "Category.Time.Undetermined".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
