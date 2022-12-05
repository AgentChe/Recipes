//
//  LibraryTableRecipeCell.swift
//  Recipes
//
//  Created by Андрей Чернышев on 22.07.2022.
//

import UIKit
import Kingfisher

final class LibraryTableRecipeCell: UITableViewCell {
    lazy var recipeImageView = makeImageView()
    lazy var nameLabel = makeLabel()
    lazy var timeIconView = makeTimeIconView()
    lazy var timeLabel = makeLabel()
    lazy var progressView = makeProgressView()
    lazy var menuButton = makeMenuButton()
    lazy var undeterminedTimeLabel = makeUndeterminedTimeLabel()
    
    private lazy var nameLabelTopConstraint = NSLayoutConstraint()
    private lazy var timeLabelTopConstraint = NSLayoutConstraint()
    
    private var menuTapped: (() -> Void)?
    
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
extension LibraryTableRecipeCell {
    func setup(element: LibraryTableRecipeElement, menuTapped: @escaping () -> Void) {
        self.menuTapped = menuTapped
        
        let recipe = element.recipe
        
        recipeImageView.kf.setImage(with: recipe.imageUrl)
        
        nameLabel.attributedText = recipe.name
            .attributed(with: TextAttributes()
                            .textColor(Appearance.black)
                            .font(Fonts.PlusJakartaSans.semiBold(size: 16.scale))
                            .lineHeight(20.8.scale)
                            .letterSpacing(-0.17.scale)
                            .lineBreakMode(.byTruncatingTail))
        
        let totalTime = (recipe.timePreparing ?? 0) + (recipe.timeCooking ?? 0)
        
        timeIconView.isHidden = totalTime == 0
        timeLabel.isHidden = totalTime == 0
        undeterminedTimeLabel.isHidden = totalTime != 0
        
        let time = String(format: "Library.Time".localized, totalTime)
        timeLabel.attributedText = time
            .attributed(with: TextAttributes()
                            .textColor(Appearance.black.withAlphaComponent(0.5))
                            .font(Fonts.PlusJakartaSans.regular(size: 16.scale))
                            .lineHeight(24.scale)
                            .letterSpacing(-0.17.scale)
                            .lineBreakMode(.byTruncatingTail))
        
        progressView.isHidden = element.progress == nil
        if let progress = element.progress {
            progressView.progress = progress
        }
        
        nameLabelTopConstraint.isActive = false
        timeLabelTopConstraint.isActive = false
        
        nameLabelTopConstraint.constant = element.progress == nil ? 7.5.scale : 0
        timeLabelTopConstraint.constant = element.progress == nil ? 33.5.scale : 26.scale
        
        nameLabelTopConstraint.isActive = true
        timeLabelTopConstraint.isActive = true
        
        contentView.layoutIfNeeded()
    }
}

// MARK: Private
private extension LibraryTableRecipeCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
    
    @objc
    func didTappedMenu() {
        menuTapped?()
    }
}

// MARK: Make constraints
private extension LibraryTableRecipeCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            recipeImageView.widthAnchor.constraint(equalToConstant: 80.scale),
            recipeImageView.heightAnchor.constraint(equalToConstant: 65.scale),
            recipeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            recipeImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        nameLabelTopConstraint = nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 106.scale),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -47.scale),
            nameLabelTopConstraint
        ])
        
        NSLayoutConstraint.activate([
            timeIconView.widthAnchor.constraint(equalToConstant: 24.scale),
            timeIconView.heightAnchor.constraint(equalToConstant: 24.scale),
            timeIconView.trailingAnchor.constraint(equalTo: timeLabel.leadingAnchor),
            timeIconView.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor)
        ])
        
        timeLabelTopConstraint = timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 26.scale)
        NSLayoutConstraint.activate([
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 130.scale),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -47.scale),
            timeLabelTopConstraint
        ])
        
        NSLayoutConstraint.activate([
            undeterminedTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 130.scale),
            undeterminedTimeLabel.topAnchor.constraint(equalTo: timeLabel.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 106.scale),
            progressView.widthAnchor.constraint(equalToConstant: 140.scale),
            progressView.heightAnchor.constraint(equalToConstant: 6.scale),
            progressView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            menuButton.widthAnchor.constraint(equalToConstant: 24.scale),
            menuButton.heightAnchor.constraint(equalToConstant: 24.scale),
            menuButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            menuButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension LibraryTableRecipeCell {
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
        view.image = UIImage(named: "Library.Time")
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
        view.attributedText = "Library.Time.Undetermined".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeProgressView() -> UIProgressView {
        let view = UIProgressView()
        view.layer.cornerRadius = 3.scale
        view.layer.masksToBounds = true
        view.trackTintColor = Appearance.secondary5
        view.progressTintColor = Appearance.primaryYellow
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeMenuButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Library.Menu"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(didTappedMenu), for: .touchUpInside)
        contentView.addSubview(view)
        return view
    }
}
