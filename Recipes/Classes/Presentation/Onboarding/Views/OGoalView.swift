//
//  OGoalView.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 23.08.2022.
//

import UIKit

protocol OGoalViewDelegate: AnyObject {
    func goalViewDidSelected(goal: OGoalButton.Goal)
}

// TODO: Figma images
final class OGoalView: OSlideView {
    weak var goalDelegate: OGoalViewDelegate?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var discoverButton = makeDiscoverButton()
    lazy var reviewButton = makeReviewButton()
    lazy var developButton = makeDevelopButton()
    lazy var nextButton = makeNextButton()
    
    private lazy var buttons = [
        discoverButton,
        reviewButton,
        developButton
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
            .logEvent(name: "Goal Screen")
    }
}

// MARK: Private
private extension OGoalView {
    func initialize() {
        backgroundColor = Appearance.background
    }
    
    @objc
    func goalTapped(sender: UIButton) {
        guard let goalButton = sender as? OGoalButton else {
            return
        }
        
        buttons.forEach { $0.marked = false }
        
        goalButton.marked = true
        
        checkEnabled()
    }
    
    @objc
    func nextTapped() {
        guard let goal = buttons.first(where: { $0.marked })?.goal else {
            return
        }
        
        goalDelegate?.goalViewDidSelected(goal: goal)
        
        onNext()
    }
    
    func checkEnabled() {
        let marked = buttons.contains(where: { $0.marked })
        nextButton.isEnabled = marked
        nextButton.alpha = marked ? 1 : 0.4
    }
}

// MARK: Make constraints
private extension OGoalView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 288.scale : 158.scale)
        ])
        
        NSLayoutConstraint.activate([
            discoverButton.widthAnchor.constraint(equalToConstant: 305.scale),
            discoverButton.heightAnchor.constraint(equalToConstant: 80.scale),
            discoverButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24.scale),
            discoverButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            reviewButton.widthAnchor.constraint(equalToConstant: 305.scale),
            reviewButton.heightAnchor.constraint(equalToConstant: 80.scale),
            reviewButton.topAnchor.constraint(equalTo: discoverButton.bottomAnchor, constant: 16.scale),
            reviewButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            developButton.widthAnchor.constraint(equalToConstant: 305.scale),
            developButton.heightAnchor.constraint(equalToConstant: 80.scale),
            developButton.topAnchor.constraint(equalTo: reviewButton.bottomAnchor, constant: 16.scale),
            developButton.centerXAnchor.constraint(equalTo: centerXAnchor)
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
private extension OGoalView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.bold(size: 28.scale))
            .lineHeight(36.4.scale)
            .letterSpacing(-0.37.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.Goal.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeDiscoverButton() -> OGoalButton {
        let goal = OGoalButton.Goal(code: 0,
                                    icon: "Onboarding.Goal.1",
                                    title: "Onboarding.Goal.1.Title".localized,
                                    subTitle: "Onboarding.Goal.1.SubTitle".localized)
        let view = OGoalButton(goal: goal)
        view.backgroundColor = Appearance.white
        view.layer.cornerRadius = 20.scale
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 6.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(goalTapped(sender:)), for: .touchUpInside)
        addSubview(view)
        return view
    }
    
    func makeReviewButton() -> OGoalButton {
        let goal = OGoalButton.Goal(code: 1,
                                    icon: "Onboarding.Goal.2",
                                    title: "Onboarding.Goal.2.Title".localized,
                                    subTitle: "Onboarding.Goal.2.SubTitle".localized)
        let view = OGoalButton(goal: goal)
        view.backgroundColor = Appearance.white
        view.layer.cornerRadius = 20.scale
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 6.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(goalTapped(sender:)), for: .touchUpInside)
        addSubview(view)
        return view
    }
    
    func makeDevelopButton() -> OGoalButton {
        let goal = OGoalButton.Goal(code: 2,
                                    icon: "Onboarding.Goal.3",
                                    title: "Onboarding.Goal.3.Title".localized,
                                    subTitle: "Onboarding.Goal.3.SubTitle".localized)
        let view = OGoalButton(goal: goal)
        view.backgroundColor = Appearance.white
        view.layer.cornerRadius = 20.scale
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 6.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(goalTapped(sender:)), for: .touchUpInside)
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
