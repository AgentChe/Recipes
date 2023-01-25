//
//  TabItemView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 07.07.2022.
//

import UIKit

final class TabItemView: UIButton {
    enum Mode {
        case selected, deselected
    }
    
    lazy var iconView = makeImageView()
    lazy var label = makeLabel()
    
    var mode = Mode.deselected {
        didSet {
            update()
        }
    }
    
    private let iconName: String
    private let name: String
    
    init(iconName: String, name: String) {
        self.iconName = iconName
        self.name = name
        
        super.init(frame: .zero)
        
        makeConstraints()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension TabItemView {
    func update() {
        let color: UIColor
        let font: UIFont
        let icon: UIImage?
        
        switch mode {
        case .selected:
            color = Appearance.primaryYellow
            font = Fonts.PlusJakartaSans.bold(size: 12.scale)
            icon = UIImage(named: iconName + ".Selected")
            alpha = 1
        case .deselected:
            color = Appearance.black
            font = Fonts.PlusJakartaSans.semiBold(size: 12.scale)
            icon = UIImage(named: iconName + ".Deselected")
            alpha = 0.5
        }
        
        let attrs = TextAttributes()
            .textColor(color)
            .font(font)
            .lineHeight(14.4.scale)
            .letterSpacing(-0.17.scale)
            .textAlignment(.center)
        label.attributedText = name.localized.attributed(with: attrs)
        
        iconView.image = icon
    }
}

// MARK: Make constraints
private extension TabItemView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24.scale),
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.topAnchor.constraint(equalTo: topAnchor, constant: 4.scale)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 6.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TabItemView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
