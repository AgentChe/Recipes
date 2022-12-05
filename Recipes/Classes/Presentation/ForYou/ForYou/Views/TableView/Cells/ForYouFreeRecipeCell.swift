//
//  ForYouFreeRecipeCell.swift
//  Recipes
//
//  Created by Андрей Чернышев on 07.07.2022.
//

import UIKit
import Kingfisher

final class ForYouFreeRecipeCell: UITableViewCell {
    lazy var placeholder1View = makePlaceholder1View()
    lazy var placeholder2View = makePlaceholder2View()
    lazy var recipeImageView = makeImageView()
    lazy var freeLabel = makeFreeLabel()
    lazy var nameLabel = makeLabel(numberOfLines: 2)
    lazy var timeLabel = makeLabel(numberOfLines: 1)
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
extension ForYouFreeRecipeCell {
    func setup(element: RecipeCover) {
        recipeImageView.kf.setImage(with: element.imageUrl)
        
        nameLabel.attributedText = element.name
            .attributed(with: TextAttributes()
                            .textColor(Appearance.black)
                            .font(Fonts.PlusJakartaSans.bold(size: 16.scale))
                            .lineHeight(19.2.scale)
                            .letterSpacing(-0.17.scale)
                            .textAlignment(.center)
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
                            .letterSpacing(-0.17.scale))
    }
}

// MARK: Private
private extension ForYouFreeRecipeCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension ForYouFreeRecipeCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            placeholder1View.widthAnchor.constraint(equalToConstant: 294.scale),
            placeholder1View.heightAnchor.constraint(equalToConstant: 309.scale),
            placeholder1View.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            placeholder1View.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            placeholder2View.widthAnchor.constraint(equalToConstant: 295.scale),
            placeholder2View.heightAnchor.constraint(equalToConstant: 309.scale),
            placeholder2View.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            placeholder2View.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            recipeImageView.widthAnchor.constraint(equalToConstant: 150.scale),
            recipeImageView.heightAnchor.constraint(equalToConstant: 155.scale),
            recipeImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            recipeImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 31.scale)
        ])
        
        NSLayoutConstraint.activate([
            freeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            freeLabel.topAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: 15.scale)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 48.scale),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -48.scale),
            nameLabel.topAnchor.constraint(equalTo: freeLabel.bottomAnchor, constant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 174.scale),
            timeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5.scale)
        ])
        
        NSLayoutConstraint.activate([
            timeIconView.widthAnchor.constraint(equalToConstant: 24.scale),
            timeIconView.heightAnchor.constraint(equalToConstant: 24.scale),
            timeIconView.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor),
            timeIconView.trailingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: -4.scale)
        ])
        
        NSLayoutConstraint.activate([
            undeterminedTimeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            undeterminedTimeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ForYouFreeRecipeCell {
    func makePlaceholder1View() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.secondary5
        view.layer.cornerRadius = 30.scale
        view.transform = CGAffineTransform(rotationAngle: (-6.31 * CGFloat.pi / 180))
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makePlaceholder2View() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.white
        view.layer.cornerRadius = 30.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 20.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeFreeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.secondary1)
            .font(Fonts.PlusJakartaSans.extraBold(size: 16.scale))
            .lineHeight(19.2.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "ForYou.FreeButton.Free".localized.attributed(with: attrs)
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
        contentView.addSubview(view)
        return view
    }
}
