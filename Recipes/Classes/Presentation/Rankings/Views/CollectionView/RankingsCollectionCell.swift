//
//  RankingsCollectionCell.swift
//  Recipes
//
//  Created by Андрей Чернышев on 19.07.2022.
//

import UIKit

final class RankingsCollectionCell: UICollectionViewCell {
    lazy var nameLabel = makeNameLabel()
    lazy var separator = makeSeparator()
    
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
extension RankingsCollectionCell {
    static func width(for element: RankingsCollectionElement) -> CGFloat {
        let attrs = TextAttributes()
            .font(Fonts.PlusJakartaSans.semiBold(size: 16.scale))
            .lineHeight(20.8.scale)
            .letterSpacing(-0.17.scale)
        let string = element.ranking.name.attributed(with: attrs)
        return string.size().width
    }
    
    func setup(element: RankingsCollectionElement) {
        let attrs = TextAttributes()
            .textColor(element.isSelected ? Appearance.primaryYellow : Appearance.black)
            .font(Fonts.PlusJakartaSans.semiBold(size: 16.scale))
            .lineHeight(20.8.scale)
            .letterSpacing(-0.17.scale)
            .textAlignment(.center)
        nameLabel.attributedText = element.ranking.name.attributed(with: attrs)
        
        separator.isHidden = !element.isSelected
    }
}

// MARK: Private
private extension RankingsCollectionCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension RankingsCollectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 2.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension RankingsCollectionCell {
    func makeNameLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeSeparator() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 1.scale
        view.backgroundColor = Appearance.primaryYellow
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
}
