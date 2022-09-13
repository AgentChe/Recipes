//
//  OCategoriesCollectionCell.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 23.08.2022.
//

import UIKit

final class OCategoriesCollectionCell: UICollectionViewCell {
    lazy var container = makeContainer()
    lazy var label = makeLabel()
    
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
extension OCategoriesCollectionCell {
    static func width(for element: OCategoriesCollectionElement) -> CGFloat {
        let attrs = TextAttributes()
            .font(Fonts.PlusJakartaSans.regular(size: 14.scale))
            .lineHeight(16.8.scale)
        let string = element.title.attributed(with: attrs)
        let width = string.size().width + 60.scale
        return width
    }
    
    func setup(element: OCategoriesCollectionElement) {
        let attrs = TextAttributes()
            .textColor(element.selected ? Appearance.white : Appearance.black)
            .font(Fonts.PlusJakartaSans.regular(size: 14.scale))
            .lineHeight(16.8.scale)
        label.attributedText = element.title.attributed(with: attrs)
        
        container.backgroundColor = element.selected ? Appearance.primaryGreen : Appearance.white
    }
}

// MARK: Private
private extension OCategoriesCollectionCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension OCategoriesCollectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension OCategoriesCollectionCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 10.scale
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 6.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
