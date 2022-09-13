//
//  ONotificationsSwitch.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 24.08.2022.
//

import UIKit

final class ONotificationsSwitch: UIView {
    struct Notification {
        let code: Int
        let title: String
        let subTitle: String
    }
    
    lazy var label = makeLabel()
    lazy var switchView = makeSwitch()
    
    let notification: Notification
    
    init(notification: Notification) {
        self.notification = notification
        
        super.init(frame: .zero)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension ONotificationsSwitch {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.scale),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            switchView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24.scale),
            switchView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ONotificationsSwitch {
    func makeLabel() -> UILabel {
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
        
        let string1 = notification.title.attributed(with: attrs1)
        let string2 = notification.subTitle.attributed(with: attrs2)
        
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
    
    func makeSwitch() -> UISwitch {
        let view = UISwitch()
        view.thumbTintColor = Appearance.white
        view.tintColor = Appearance.secondary5
        view.onTintColor = Appearance.primaryGreen
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
