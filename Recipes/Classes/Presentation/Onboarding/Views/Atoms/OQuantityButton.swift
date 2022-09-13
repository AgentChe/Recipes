//
//  OQuantityButton.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 23.08.2022.
//

import UIKit

final class OQuantityButton: UIButton {
    struct Quantity {
        let code: Int
        let title: String
        let subTitle: String
    }
    
    lazy var marked = false {
        didSet {
            update()
        }
    }
    
    lazy var label = makeLabel()
    
    let quantity: Quantity
    
    init(quantity: Quantity) {
        self.quantity = quantity
        
        super.init(frame: .zero)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OQuantityButton {
    func update() {
        layer.borderWidth = marked ? 2.scale : 0
        layer.borderColor = marked ? Appearance.primaryGreen.cgColor : UIColor.clear.cgColor
    }
}

// MARK: Make constraints
private extension OQuantityButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension OQuantityButton {
    func makeLabel() -> UILabel {
        let attrs1 = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.bold(size: 16.scale))
            .lineHeight(22.4.scale)
            .letterSpacing(-0.17.scale)
            .textAlignment(.center)
        
        let attrs2 = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.regular(size: 16.scale))
            .lineHeight(22.4.scale)
            .letterSpacing(-0.17.scale)
            .textAlignment(.center)
        
        let string1 = quantity.title.attributed(with: attrs1)
        let string2 = quantity.subTitle.attributed(with: attrs2)
        
        let result = NSMutableAttributedString()
        result.append(string1)
        result.append(string2)
        
        let view = UILabel()
        view.attributedText = result
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
