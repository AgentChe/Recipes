//
//  ChallengeHeaderCell.swift
//  Recipes
//
//  Created by Андрей Чернышев on 17.08.2022.
//

import UIKit

final class ChallengeHeaderCell: UITableViewCell {
    lazy var nameLabel = makeLabel()
    lazy var titleLabel = makeLabel()
    lazy var txtLabel = makeLabel()
    
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
extension ChallengeHeaderCell {
    func setup(name: String, title: String, text: String) {
        nameLabel.attributedText = name
            .attributed(with: TextAttributes()
                            .textColor(Appearance.secondary2)
                            .font(Fonts.PlusJakartaSans.extraBold(size: 16.scale))
                            .lineHeight(19.2.scale))
        
        titleLabel.attributedText = title
            .attributed(with: TextAttributes()
                            .textColor(Appearance.black)
                            .font(Fonts.PlusJakartaSans.bold(size: 28.scale))
                            .lineHeight(41.scale)
                            .letterSpacing(0.37.scale))
        
        txtLabel.attributedText = text
            .attributed(with: TextAttributes()
                            .textColor(Appearance.black)
                            .font(Fonts.PlusJakartaSans.regular(size: 16.scale))
                            .lineHeight(24.scale)
                            .letterSpacing(-0.17.scale))
    }
}

// MARK: Private
private extension ChallengeHeaderCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension ChallengeHeaderCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            txtLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            txtLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            txtLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10.scale),
            txtLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ChallengeHeaderCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
