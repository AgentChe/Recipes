//
//  OPaceView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 24.08.2022.
//

import UIKit

protocol OPaceViewDelegate: AnyObject {
    func paceViewDidSelected(pace: Int)
}

final class OPaceView: OSlideView {
    weak var paceDelegate: OPaceViewDelegate?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var icon1View = makeIconView(name: "Onboarding.Pace1")
    lazy var icon2View = makeIconView(name: "Onboarding.Pace2")
    lazy var icon3View = makeIconView(name: "Onboarding.Pace3")
    lazy var slider = makeSlider()
    lazy var label1 = makeLabel1()
    lazy var label2 = makeLabel2()
    lazy var label3 = makeLabel3()
    lazy var backButton = makeBackButton()
    lazy var nextButton = makeNextButton()
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
        initialize()
        update(sender: slider)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func moveToThis() {
        super.moveToThis()
        
        AmplitudeManager.shared
            .logEvent(name: "Pace Screen")
    }
}

// MARK: Private
private extension OPaceView {
    func initialize() {
        backgroundColor = Appearance.background
    }
    
    @objc
    func update(sender: UISlider) {
        let value = round(sender.value)
        sender.value = value
        
        label1.alpha = value >= 1 ? 1 : 0.5
        label2.alpha = value >= 2 ? 1 : 0.5
        label3.alpha = value >= 3 ? 1 : 0.5
    }
    
    @objc
    func nextTapped() {
        let pace = Int(self.slider.value)
        paceDelegate?.paceViewDidSelected(pace: pace)
        
        onNext()
    }
}

// MARK: Make constraints
private extension OPaceView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 126.scale : 62.scale)
        ])
        
        NSLayoutConstraint.activate([
            icon1View.widthAnchor.constraint(equalToConstant: 70.scale),
            icon1View.heightAnchor.constraint(equalToConstant: 70.scale),
            icon1View.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.scale),
            icon1View.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 436.scale : 330.scale)
        ])
        
        NSLayoutConstraint.activate([
            icon2View.widthAnchor.constraint(equalToConstant: 70.scale),
            icon2View.heightAnchor.constraint(equalToConstant: 70.scale),
            icon2View.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 152.scale),
            icon2View.centerYAnchor.constraint(equalTo: icon1View.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            icon3View.widthAnchor.constraint(equalToConstant: 70.scale),
            icon3View.heightAnchor.constraint(equalToConstant: 70.scale),
            icon3View.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 285.scale),
            icon3View.centerYAnchor.constraint(equalTo: icon1View.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            slider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.scale),
            slider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24.scale),
            slider.heightAnchor.constraint(equalToConstant: 32.scale),
            slider.topAnchor.constraint(equalTo: icon1View.bottomAnchor, constant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            label1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.scale),
            label1.topAnchor.constraint(equalTo: icon1View.bottomAnchor, constant: 52.scale)
        ])
        
        NSLayoutConstraint.activate([
            label2.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 143.scale),
            label2.centerYAnchor.constraint(equalTo: label1.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label3.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 280.scale),
            label3.centerYAnchor.constraint(equalTo: label1.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 54.scale),
            backButton.heightAnchor.constraint(equalToConstant: 54.scale),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.scale),
            backButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -20.scale)
        ])
        
        NSLayoutConstraint.activate([
            nextButton.widthAnchor.constraint(equalToConstant: 239.scale),
            nextButton.heightAnchor.constraint(equalToConstant: 54.scale),
            nextButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 101.scale),
            nextButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -20.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OPaceView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.bold(size: 28.scale))
            .letterSpacing(-0.37.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.Pace.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeIconView(name: String) -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: name)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSlider() -> UISlider {
        let view = UISlider()
        view.minimumValue = 1
        view.maximumValue = 3
        view.thumbTintColor = Appearance.primaryYellow
        view.maximumTrackTintColor = Appearance.secondary5
        view.minimumTrackTintColor = Appearance.primaryYellow
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(update(sender:)), for: .valueChanged)
        addSubview(view)
        return view
    }
    
    func makeLabel1() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.semiBold(size: 14.scale))
            .lineHeight(19.6.scale)
            .letterSpacing(-0.17.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Onboarding.Pace1".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel2() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.semiBold(size: 14.scale))
            .lineHeight(19.6.scale)
            .letterSpacing(-0.17.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Onboarding.Pace2".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel3() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.semiBold(size: 14.scale))
            .lineHeight(19.6.scale)
            .letterSpacing(-0.17.scale)
            .textAlignment(.right)
        
        let view = UILabel()
        view.attributedText = "Onboarding.Pace3".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
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
    
    func makeNextButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.semiBold(size: 16.scale))
            .letterSpacing(-0.17.scale)
        
        let view = UIButton()
        view.backgroundColor = Appearance.primaryYellow
        view.layer.cornerRadius = 16.scale
        view.setAttributedTitle("Onboarding.Pace.Button".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        addSubview(view)
        return view
    }
}
