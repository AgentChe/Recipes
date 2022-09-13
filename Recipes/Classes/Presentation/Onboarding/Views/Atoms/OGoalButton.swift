//
//  OGoalButton.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 23.08.2022.
//

import UIKit

final class OGoalButton: UIButton {
    struct Goal {
        let code: Int
        let icon: String
        let title: String
        let subTitle: String
    }
    
    lazy var marked = false {
        didSet {
            update()
        }
    }
    
    let goal: Goal
    
    lazy var iconView = makeIconView()
    lazy var textLabel = makeTextLabel()
    
    init(goal: Goal) {
        self.goal = goal
        
        super.init(frame: .zero)
        
        makeConstraints()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OGoalButton {
    func update() {
        layer.borderColor = marked ? Appearance.primaryGreen.cgColor : UIColor.clear.cgColor
        layer.borderWidth = marked ? 2.scale : 0
    }
}

// MARK: Make constraints
private extension OGoalButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 46.scale),
            iconView.heightAnchor.constraint(equalToConstant: 42.scale),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18.scale),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 84.scale),
            textLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension OGoalButton {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: goal.icon)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTextLabel() -> UILabel {
        let attrs1 = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.bold(size: 16.scale))
            .lineHeight(24.scale)
            .letterSpacing(-0.17.scale)
        
        let attrs2 = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.regular(size: 16.scale))
            .lineHeight(24.scale)
            .letterSpacing(-0.17.scale)
        
        let string1 = goal.title.attributed(with: attrs1)
        let string2 = goal.subTitle.attributed(with: attrs2)
        
        let result = NSMutableAttributedString()
        result.append(string1)
        result.append(string2)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = result
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
