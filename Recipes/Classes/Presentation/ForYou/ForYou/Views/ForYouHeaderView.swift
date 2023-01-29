//
//  ForYouHeaderView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 29.01.2023.
//

import UIKit

final class ForYouHeaderView: UIView {
    enum Mode {
        case leadingTitle, navTitle
    }
    
    lazy var titleLabel = makeTitleLabel()
    lazy var settingsButton = makeSettingsButton()
    
    private lazy var mode = Mode.leadingTitle
    
    private lazy var labelLeadingConstraint = NSLayoutConstraint()
    private lazy var labelTopConstraint = NSLayoutConstraint()
    private lazy var labelCenterXConstraint = NSLayoutConstraint()
    private lazy var labelCenterYConstraint = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        updateTitle(by: mode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ForYouHeaderView {
    func updateTitle(by mode: Mode) {
        guard self.mode != mode else {
            return
        }
        
        self.mode = mode
        
        deactivateAllLabelConstraints()
        applyAttributedForLabel()
        activateLabelConstraints()
        
        layoutIfNeeded()
    }
}

// MARK: Private
private extension ForYouHeaderView {
    func deactivateAllLabelConstraints() {
        NSLayoutConstraint.deactivate([
            labelLeadingConstraint,
            labelTopConstraint,
            labelCenterXConstraint,
            labelCenterYConstraint
        ])
    }
    
    func applyAttributedForLabel() {
        let attrs: TextAttributes
        switch mode {
        case .leadingTitle:
            attrs = TextAttributes()
                .textColor(Appearance.black)
                .font(Fonts.PlusJakartaSans.extraBold(size: 34.scale))
                .lineHeight(40.8.scale)
                .letterSpacing(-1.scale)
        case .navTitle:
            attrs = TextAttributes()
                .textColor(Appearance.black)
                .font(Fonts.PlusJakartaSans.bold(size: 20.scale))
                .lineHeight(24.scale)
                .letterSpacing(-0.17.scale)
        }
        titleLabel.attributedText = "ForYou.Title".localized.attributed(with: attrs)
    }
    
    func activateLabelConstraints() {
        switch mode {
        case .leadingTitle:
            labelLeadingConstraint = titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale)
            labelTopConstraint = titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 91.scale : 61.scale)
            NSLayoutConstraint.activate([
                labelLeadingConstraint,
                labelTopConstraint
            ])
        case .navTitle:
            labelCenterXConstraint = titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
            labelCenterYConstraint = titleLabel.centerYAnchor.constraint(equalTo: settingsButton.centerYAnchor)
            NSLayoutConstraint.activate([
                labelCenterXConstraint,
                labelCenterYConstraint
            ])
        }
    }
}

// MARK: Make constraints
private extension ForYouHeaderView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            settingsButton.widthAnchor.constraint(equalToConstant: 24.scale),
            settingsButton.heightAnchor.constraint(equalToConstant: 24.scale),
            settingsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -19.scale),
            settingsButton.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 54.scale : 34.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ForYouHeaderView {
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSettingsButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "ForYou.Settings"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
