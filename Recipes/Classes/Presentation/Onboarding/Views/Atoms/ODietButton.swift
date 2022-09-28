//
//  ODietButton.swift
//  Recipes
//
//  Created by Андрей Чернышев on 14.09.2022.
//

import UIKit

final class ODietButton: UIButton {
    lazy var marked = false {
        didSet {
            update()
        }
    }
    
    lazy var nameLabel = makeLabel()
    
    private let age: String
    
    init(age: String) {
        self.age = age
        
        super.init(frame: .zero)
        
        makeConstraints()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension ODietButton {
    func update() {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.semiBold(size: 16.scale))
            .lineHeight(24.scale)
            .letterSpacing(-0.17.scale)
        nameLabel.attributedText = age.attributed(with: attrs)
        
        backgroundColor = marked ? Appearance.primaryYellow : Appearance.white
    }
}

// MARK: Make constraints
private extension ODietButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ODietButton {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
