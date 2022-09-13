//
//  OTimeButton.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 24.08.2022.
//

import UIKit

final class OTimeButton: UIButton {
    struct Time {
        let code: Int
        let icon: String
        let title: String
    }
    
    lazy var marked = false {
        didSet {
            update()
        }
    }
    
    lazy var iconView = makeIconView()
    lazy var label = makeLabel()
    
    let time: Time
    
    init(time: Time) {
        self.time = time
        
        super.init(frame: .zero)
        
        makeConstraints()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OTimeButton {
    func update() {
        layer.borderWidth = marked ? 2.scale : 0
        layer.borderColor = marked ? Appearance.primaryGreen.cgColor : UIColor.clear.cgColor
    }
}

// MARK: Make constraints
private extension OTimeButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 49.scale),
            iconView.heightAnchor.constraint(equalToConstant: 49.scale),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 77.scale),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension OTimeButton {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: time.icon)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.semiBold(size: 16.scale))
            .lineHeight(24.scale)
            .letterSpacing(-0.17.scale)
        
        let view = UILabel()
        view.attributedText = time.title.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
