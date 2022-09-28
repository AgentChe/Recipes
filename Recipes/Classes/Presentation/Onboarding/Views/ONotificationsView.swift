//
//  ONotificationsView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 24.08.2022.
//

import UIKit

protocol ONotificationsViewDelegate: AnyObject {
    func notificationsViewDidRegistered(pushToken: String?, options: [ONotificationsSwitch.Notification])
}

final class ONotificationsView: OSlideView {
    weak var notificationsDelegate: ONotificationsViewDelegate?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var stayMotivatedSwitch = makeStayMotivatedSwitch()
    lazy var separator = makeSeparator()
    lazy var diveDeeperSwitch = makeDiveDeeperSwitch()
    lazy var saveButton = makeSaveButton()
    lazy var notNowButton = makeNotNowButton()
    
    override init(step: OnboardingView.Step) {
        super.init(step: step)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func moveToThis() {
        super.moveToThis()
        
        PushNotificationsManager.shared.add(observer: self)
        
        AmplitudeManager.shared
            .logEvent(name: "Notifications Screen")
    }
}

// MARK: PushNotificationsDelegate
extension ONotificationsView: PushNotificationsDelegate {
    func pushNotificationsDidReceive(authorizationStatus: PushNotificationsAuthorizationStatus) {}
    func pushNotificationsDidReceive(model: PushNotificationsModel) {}
    
    func pushNotificationsDidReceive(token: String?) {
        let notifications = [stayMotivatedSwitch, diveDeeperSwitch]
            .filter { $0.switchView.isOn }
            .map { $0.notification }
        
        notificationsDelegate?.notificationsViewDidRegistered(pushToken: token, options: notifications)
        
        PushNotificationsManager.shared.remove(observer: self)
        
        onNext()
    }
}

// MARK: Private
private extension ONotificationsView {
    func initialize() {
        backgroundColor = Appearance.background
    }
    
    @objc
    func saveTapped() {
        PushNotificationsManager.shared.requestAuthorization()
    }
}

// MARK: Make constraints
private extension ONotificationsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 245.scale : 145.scale)
        ])
        
        NSLayoutConstraint.activate([
            stayMotivatedSwitch.leadingAnchor.constraint(equalTo: leadingAnchor),
            stayMotivatedSwitch.trailingAnchor.constraint(equalTo: trailingAnchor),
            stayMotivatedSwitch.heightAnchor.constraint(equalToConstant: 72.scale),
            stayMotivatedSwitch.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 23.scale)
        ])
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.scale),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24.scale),
            separator.heightAnchor.constraint(equalToConstant: 1.scale),
            separator.topAnchor.constraint(equalTo: stayMotivatedSwitch.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            diveDeeperSwitch.leadingAnchor.constraint(equalTo: leadingAnchor),
            diveDeeperSwitch.trailingAnchor.constraint(equalTo: trailingAnchor),
            diveDeeperSwitch.heightAnchor.constraint(equalToConstant: 72.scale),
            diveDeeperSwitch.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            saveButton.widthAnchor.constraint(equalToConstant: 305.scale),
            saveButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: notNowButton.topAnchor, constant: -16.scale),
            saveButton.heightAnchor.constraint(equalToConstant: 53.scale)
        ])
        
        NSLayoutConstraint.activate([
            notNowButton.widthAnchor.constraint(equalToConstant: 305.scale),
            notNowButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            notNowButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -60.scale : -20.scale),
            notNowButton.heightAnchor.constraint(equalToConstant: 53.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ONotificationsView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.bold(size: 26.scale))
            .letterSpacing(-0.37.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "Onboarding.Notifications.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeStayMotivatedSwitch() -> ONotificationsSwitch {
        let notification = ONotificationsSwitch
            .Notification(code: 0,
                          title: "Onboarding.Notifications.Cell1.Title".localized,
                          subTitle: "Onboarding.Notifications.Cell1.SubTitle".localized)
        let view = ONotificationsSwitch(notification: notification)
        view.switchView.isOn = true
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.secondary5
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeDiveDeeperSwitch() -> ONotificationsSwitch {
        let notification = ONotificationsSwitch
            .Notification(code: 1,
                          title: "Onboarding.Notifications.Cell2.Title".localized,
                          subTitle: "Onboarding.Notifications.Cell2.SubTitle".localized)
        let view = ONotificationsSwitch(notification: notification)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSaveButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.semiBold(size: 16.scale))
            .letterSpacing(-0.17.scale)
        
        let view = UIButton()
        view.backgroundColor = Appearance.primaryYellow
        view.layer.cornerRadius = 16.scale
        view.setAttributedTitle("Onboarding.Notifications.SaveButton".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        addSubview(view)
        return view
    }
    
    func makeNotNowButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.semiBold(size: 16.scale))
            .letterSpacing(-0.17.scale)
        
        let view = UIButton()
        view.backgroundColor = Appearance.secondary5
        view.layer.cornerRadius = 16.scale
        view.setAttributedTitle("Onboarding.Notifications.SkipButton".localized.attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(onNext), for: .touchUpInside)
        addSubview(view)
        return view
    }
}
