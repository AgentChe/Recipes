//
//  OQuantityView.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 23.08.2022.
//

import UIKit

protocol OQuantityViewDelegate: AnyObject {
    func quantityViewDidSelected(quantity: OQuantityButton.Quantity)
}

final class OQuantityView: OSlideView {
    weak var quantityDelegate: OQuantityViewDelegate?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var casualButton = makeCasualButton()
    lazy var regularButton = makeRegularButton()
    lazy var seriousButton = makeSeriousButton()
    lazy var backButton = makeBackButton()
    lazy var nextButton = makeNextButton()
    
    private lazy var buttons = [
        casualButton,
        regularButton,
        seriousButton
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
            .logEvent(name: "Quantity Screen")
    }
}

// MARK: Private
private extension OQuantityView {
    func initialize() {
        backgroundColor = Appearance.background
    }
    
    @objc
    func quantityTapped(sender: UIButton) {
        guard let quantityButton = sender as? OQuantityButton else {
            return
        }
        
        buttons.forEach { $0.marked = false }
        
        quantityButton.marked = true
        
        checkEnabled()
    }
    
    @objc
    func nextTapped() {
        guard let quantity = buttons.first(where: { $0.marked })?.quantity else {
            return
        }
        
        quantityDelegate?.quantityViewDidSelected(quantity: quantity)
        
        onNext()
    }
    
    func checkEnabled() {
        let marked = buttons.contains(where: { $0.marked })
        nextButton.isEnabled = marked
        nextButton.alpha = marked ? 1 : 0.4
    }
}

// MARK: Make constraints
private extension OQuantityView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 135.scale : 80.scale)
        ])
        
        NSLayoutConstraint.activate([
            casualButton.widthAnchor.constraint(equalToConstant: 305.scale),
            casualButton.heightAnchor.constraint(equalToConstant: 84.scale),
            casualButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            casualButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            regularButton.widthAnchor.constraint(equalToConstant: 305.scale),
            regularButton.heightAnchor.constraint(equalToConstant: 84.scale),
            regularButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            regularButton.topAnchor.constraint(equalTo: casualButton.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            seriousButton.widthAnchor.constraint(equalToConstant: 305.scale),
            seriousButton.heightAnchor.constraint(equalToConstant: 84.scale),
            seriousButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            seriousButton.topAnchor.constraint(equalTo: regularButton.bottomAnchor, constant: 16.scale)
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
private extension OQuantityView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.bold(size: 28.scale))
            .letterSpacing(-0.37.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.Quantity.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCasualButton() -> OQuantityButton {
        let quantity = OQuantityButton.Quantity(code: 0,
                                                title: "Onboarding.Quantity.Casual.Title".localized,
                                                subTitle: "Onboarding.Quantity.Casual.SubTitle".localized)
        let view = OQuantityButton(quantity: quantity)
        view.backgroundColor = Appearance.white
        view.layer.cornerRadius = 20.scale
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 6.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(quantityTapped(sender:)), for: .touchUpInside)
        addSubview(view)
        return view
    }
    
    func makeRegularButton() -> OQuantityButton {
        let quantity = OQuantityButton.Quantity(code: 0,
                                                title: "Onboarding.Quantity.Regular.Title".localized,
                                                subTitle: "Onboarding.Quantity.Regular.SubTitle".localized)
        let view = OQuantityButton(quantity: quantity)
        view.backgroundColor = Appearance.white
        view.layer.cornerRadius = 20.scale
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 6.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(quantityTapped(sender:)), for: .touchUpInside)
        addSubview(view)
        return view
    }
    
    func makeSeriousButton() -> OQuantityButton {
        let quantity = OQuantityButton.Quantity(code: 0,
                                                title: "Onboarding.Quantity.Serious.Title".localized,
                                                subTitle: "Onboarding.Quantity.Serious.SubTitle".localized)
        let view = OQuantityButton(quantity: quantity)
        view.backgroundColor = Appearance.white
        view.layer.cornerRadius = 20.scale
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 6.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(quantityTapped(sender:)), for: .touchUpInside)
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
        view.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        addSubview(view)
        return view
    }
}
