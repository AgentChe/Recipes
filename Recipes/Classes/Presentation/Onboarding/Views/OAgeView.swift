//
//  OAgeView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 23.08.2022.
//

import UIKit

final class OAgeView: OSlideView {
    lazy var titleLabel = makeTitleLabel()
    lazy var age1Button = makeAgeButton(age: "Onboarding.Age.1".localized)
    lazy var age2Button = makeAgeButton(age: "Onboarding.Age.2".localized)
    lazy var age3Button = makeAgeButton(age: "Onboarding.Age.3".localized)
    lazy var age4Button = makeAgeButton(age: "Onboarding.Age.4".localized)
    lazy var age5Button = makeAgeButton(age: "Onboarding.Age.5".localized)
    lazy var backButton = makeBackButton()
    lazy var nextButton = makeNextButton()
    
    private lazy var buttons = [
        age1Button,
        age2Button,
        age3Button,
        age4Button,
        age5Button
    ]
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
        initialize()
        checkEnabled()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func moveToThis() {
        super.moveToThis()
        
        AmplitudeManager.shared
            .logEvent(name: "Age Screen")
    }
}

// MARK: Private
private extension OAgeView {
    func initialize() {
        backgroundColor = Appearance.background
    }
    
    @objc
    func ageTapped(sender: UIButton) {
        guard let ageButton = sender as? OAgeButton else {
            return
        }
        
        buttons.forEach { $0.marked = false }
        
        ageButton.marked = true
        
        checkEnabled()
    }
    
    func checkEnabled() {
        let marked = buttons.contains(where: { $0.marked })
        nextButton.isEnabled = marked
        nextButton.alpha = marked ? 1 : 0.4
    }
}

// MARK: Make constraints
private extension OAgeView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 147.scale : 47.scale)
        ])
        
        NSLayoutConstraint.activate([
            age1Button.widthAnchor.constraint(equalToConstant: 305.scale),
            age1Button.heightAnchor.constraint(equalToConstant: 80.scale),
            age1Button.centerXAnchor.constraint(equalTo: centerXAnchor),
            age1Button.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            age2Button.widthAnchor.constraint(equalToConstant: 305.scale),
            age2Button.heightAnchor.constraint(equalToConstant: 80.scale),
            age2Button.centerXAnchor.constraint(equalTo: centerXAnchor),
            age2Button.topAnchor.constraint(equalTo: age1Button.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            age3Button.widthAnchor.constraint(equalToConstant: 305.scale),
            age3Button.heightAnchor.constraint(equalToConstant: 80.scale),
            age3Button.centerXAnchor.constraint(equalTo: centerXAnchor),
            age3Button.topAnchor.constraint(equalTo: age2Button.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            age4Button.widthAnchor.constraint(equalToConstant: 305.scale),
            age4Button.heightAnchor.constraint(equalToConstant: 80.scale),
            age4Button.centerXAnchor.constraint(equalTo: centerXAnchor),
            age4Button.topAnchor.constraint(equalTo: age3Button.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            age5Button.widthAnchor.constraint(equalToConstant: 305.scale),
            age5Button.heightAnchor.constraint(equalToConstant: 80.scale),
            age5Button.centerXAnchor.constraint(equalTo: centerXAnchor),
            age5Button.topAnchor.constraint(equalTo: age4Button.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 54.scale),
            backButton.heightAnchor.constraint(equalToConstant: 54.scale),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.scale),
            backButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -20.scale)
        ])
        
        NSLayoutConstraint.activate([
            nextButton.widthAnchor.constraint(equalToConstant: 54.scale),
            nextButton.heightAnchor.constraint(equalToConstant: 54.scale),
            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24.scale),
            nextButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -20.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OAgeView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.bold(size: 28.scale))
            .lineHeight(36.4.scale)
            .letterSpacing(-0.37.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.Age.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeAgeButton(age: String) -> OAgeButton {
        let view = OAgeButton(age: age)
        view.layer.cornerRadius = 20.scale
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 6.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(ageTapped(sender:)), for: .touchUpInside)
        addSubview(view)
        return view
    }
    
    func makeBackButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Onboarding.Back"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(onBack), for: .touchUpInside)
        addSubview(view)
        return view
    }
    
    func makeNextButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Onboarding.Next"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(onNext), for: .touchUpInside)
        addSubview(view)
        return view
    }
}
