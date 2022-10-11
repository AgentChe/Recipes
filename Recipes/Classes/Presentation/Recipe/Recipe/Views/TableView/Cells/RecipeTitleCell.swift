//
//  RecipeTitleCell.swift
//  Recipes
//
//  Created by Андрей Чернышев on 11.10.2022.
//

import UIKit

final class RecipeTitleCell: UITableViewCell {
    lazy var label = makeLabel()
    
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
extension RecipeTitleCell {
    func setup(element: String) {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.bold(size: 20.scale))
            .lineHeight(24.scale)
            .letterSpacing(-0.17.scale)
        label.attributedText = element.attributed(with: attrs)
    }
}

// MARK: Private
private extension RecipeTitleCell {
    func initialize() {
        backgroundColor = Appearance.background
        contentView.backgroundColor = Appearance.background
        
        selectionStyle = .none
    }
}

// MARK: Make constraints
private extension RecipeTitleCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension RecipeTitleCell {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
