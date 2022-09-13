//
//  OTimeView.swift
//  BookSummaries
//
//  Created by Андрей Чернышев on 24.08.2022.
//

import UIKit

protocol OTimeViewDelegate: AnyObject {
    func timeViewDidSelected(time: OTimeButton.Time)
}

final class OTimeView: OSlideView {
    weak var timeDelegate: OTimeViewDelegate?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var button1 = makeButton1()
    lazy var button2 = makeButton2()
    lazy var button3 = makeButton3()
    lazy var button4 = makeButton4()
    lazy var button5 = makeButton5()
    lazy var backButton = makeBackButton()
    lazy var nextButton = makeNextButton()
    
    private lazy var buttons = [
        button1,
        button2,
        button3,
        button4,
        button5
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
            .logEvent(name: "Time Screen")
    }
}

// MARK: Private
private extension OTimeView {
    func initialize() {
        backgroundColor = Appearance.background
    }
    
    @objc
    func timeTapped(sender: UIButton) {
        guard let timeButton = sender as? OTimeButton else {
            return
        }
        
        buttons.forEach { $0.marked = false }
        
        timeButton.marked = true
        
        checkEnabled()
    }
    
    @objc
    func nextTapped() {
        guard let time = buttons.first(where: { $0.marked })?.time else {
            return
        }
        
        timeDelegate?.timeViewDidSelected(time: time)
        
        onNext()
    }
    
    func checkEnabled() {
        let marked = buttons.contains(where: { $0.marked })
        nextButton.isEnabled = marked
        nextButton.alpha = marked ? 1 : 0.4
    }
}

// MARK: Make constraints
private extension OTimeView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 126.scale : 62.scale)
        ])
        
        NSLayoutConstraint.activate([
            button1.widthAnchor.constraint(equalToConstant: 305.scale),
            button1.heightAnchor.constraint(equalToConstant: 72.scale),
            button1.centerXAnchor.constraint(equalTo: centerXAnchor),
            button1.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            button2.widthAnchor.constraint(equalToConstant: 305.scale),
            button2.heightAnchor.constraint(equalToConstant: 72.scale),
            button2.centerXAnchor.constraint(equalTo: centerXAnchor),
            button2.topAnchor.constraint(equalTo: button1.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            button3.widthAnchor.constraint(equalToConstant: 305.scale),
            button3.heightAnchor.constraint(equalToConstant: 72.scale),
            button3.centerXAnchor.constraint(equalTo: centerXAnchor),
            button3.topAnchor.constraint(equalTo: button2.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            button4.widthAnchor.constraint(equalToConstant: 305.scale),
            button4.heightAnchor.constraint(equalToConstant: 72.scale),
            button4.centerXAnchor.constraint(equalTo: centerXAnchor),
            button4.topAnchor.constraint(equalTo: button3.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            button5.widthAnchor.constraint(equalToConstant: 305.scale),
            button5.heightAnchor.constraint(equalToConstant: 72.scale),
            button5.centerXAnchor.constraint(equalTo: centerXAnchor),
            button5.topAnchor.constraint(equalTo: button4.bottomAnchor, constant: 16.scale)
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
private extension OTimeView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.bold(size: 28.scale))
            .letterSpacing(-0.37.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.Time.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton1() -> OTimeButton {
        let time = OTimeButton.Time(code: 0,
                                    icon: "Onboarding.Time.1",
                                    title: "Onboarding.Time.Cell1".localized)
        let view = OTimeButton(time: time)
        view.backgroundColor = Appearance.white
        view.layer.cornerRadius = 20.scale
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 6.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(timeTapped(sender:)), for: .touchUpInside)
        addSubview(view)
        return view
    }
    
    func makeButton2() -> OTimeButton {
        let time = OTimeButton.Time(code: 1,
                                    icon: "Onboarding.Time.2",
                                    title: "Onboarding.Time.Cell2".localized)
        let view = OTimeButton(time: time)
        view.backgroundColor = Appearance.white
        view.layer.cornerRadius = 20.scale
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 6.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(timeTapped(sender:)), for: .touchUpInside)
        addSubview(view)
        return view
    }
    
    func makeButton3() -> OTimeButton {
        let time = OTimeButton.Time(code: 2,
                                    icon: "Onboarding.Time.3",
                                    title: "Onboarding.Time.Cell3".localized)
        let view = OTimeButton(time: time)
        view.backgroundColor = Appearance.white
        view.layer.cornerRadius = 20.scale
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 6.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(timeTapped(sender:)), for: .touchUpInside)
        addSubview(view)
        return view
    }
    
    func makeButton4() -> OTimeButton {
        let time = OTimeButton.Time(code: 3,
                                    icon: "Onboarding.Time.4",
                                    title: "Onboarding.Time.Cell4".localized)
        let view = OTimeButton(time: time)
        view.backgroundColor = Appearance.white
        view.layer.cornerRadius = 20.scale
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 6.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(timeTapped(sender:)), for: .touchUpInside)
        addSubview(view)
        return view
    }
    
    func makeButton5() -> OTimeButton {
        let time = OTimeButton.Time(code: 4,
                                    icon: "Onboarding.Time.5",
                                    title: "Onboarding.Time.Cell5".localized)
        let view = OTimeButton(time: time)
        view.backgroundColor = Appearance.white
        view.layer.cornerRadius = 20.scale
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 6.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(timeTapped(sender:)), for: .touchUpInside)
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
