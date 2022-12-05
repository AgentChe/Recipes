//
//  ForYouRankingCell.swift
//  Recipes
//
//  Created by Андрей Чернышев on 07.07.2022.
//

import UIKit
import Kingfisher

final class ForYouRankingCell: UITableViewCell {
    lazy var recipeImageView = makeImageView()
    lazy var nameLabel = makeLabel()
    lazy var timeLabel = makeLabel()
    lazy var timeIconView = makeTimeIconView()
    lazy var undeterminedTimeLabel = makeUndeterminedTimeLabel()
    
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
extension ForYouRankingCell {
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
        
        let time = String(format: "ForYou.Time".localized, totalTime)
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
private extension ForYouRankingCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension ForYouRankingCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            recipeImageView.widthAnchor.constraint(equalToConstant: 80.scale),
            recipeImageView.heightAnchor.constraint(equalToConstant: 65.scale),
            recipeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            recipeImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 106.scale),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7.5.scale)
        ])
        
        NSLayoutConstraint.activate([
            timeIconView.widthAnchor.constraint(equalToConstant: 24.scale),
            timeIconView.heightAnchor.constraint(equalToConstant: 24.scale),
            timeIconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 106.scale),
            timeIconView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5.scale)
        ])
        
        NSLayoutConstraint.activate([
            timeLabel.leadingAnchor.constraint(equalTo: timeIconView.trailingAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: timeIconView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            undeterminedTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 106.scale),
            undeterminedTimeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ForYouRankingCell {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
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
        view.image = UIImage(named: "ForYou.Time")
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
        view.attributedText = "ForYou.Time.Undetermined".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
