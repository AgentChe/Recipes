//
//  OAgeButton.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 23.08.2022.
//

import UIKit

final class OAgeButton: UIButton {
    lazy var marked = false {
        didSet {
            update()
        }
    }
    
    lazy var ageLabel = makeLabel()
    
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
private extension OAgeButton {
    func update() {
        let attrs = TextAttributes()
            .textColor(marked ? Appearance.white : Appearance.black)
            .font(Fonts.PlusJakartaSans.semiBold(size: 16.scale))
            .lineHeight(24.scale)
            .letterSpacing(-0.17.scale)
        ageLabel.attributedText = age.attributed(with: attrs)
        
        backgroundColor = marked ? Appearance.primaryGreen : Appearance.white
    }
}

// MARK: Make constraints
private extension OAgeButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            ageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            ageLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension OAgeButton {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
