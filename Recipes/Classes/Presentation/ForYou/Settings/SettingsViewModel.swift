//
//  SettingsViewModel.swift
//  Recipes
//
//  Created by Андрей Чернышев on 09.07.2022.
//

import RxSwift
import RxCocoa

final class SettingsViewModel {
    lazy var elements = makeElements()
    
    private lazy var activeSubscription = makeActiveSubscription()
    
    private lazy var sessionManager = SessionManager()
}

// MARK: Private
private extension SettingsViewModel {
    func makeElements() -> Driver<[SettingsTableElement]> {
        activeSubscription
            .map { activeSubscription -> [SettingsTableElement] in
                var result: [SettingsTableElement] = [
                    .contactUs("Settings.ContactUs".localized),
                    .offset(20.scale),
                    .separator,
                    .offset(20.scale),
                    .privacyPolicy("Settings.PrivacyPolicy".localized),
                    .offset(20.scale),
                    .separator,
                    .offset(20.scale),
                    .termsOfUse("Settings.TermsOfUse".localized),
                ]
                
                if !activeSubscription {
                    result.append(contentsOf: [
                        .offset(60.scale),
                        .getAccess
                    ])
                }
                
                return result
            }
    }
    
    func makeActiveSubscription() -> Driver<Bool> {
        PurchaseValidationObserver.shared
            .didValidatedWithActiveSubscription
            .map { [weak self] in
                guard let self = self else {
                    return false
                }
                
                return self.sessionManager.hasActiveSubscriptions()
            }
            .startWith(sessionManager.hasActiveSubscriptions())
            .asDriver(onErrorJustReturn: false)
    }
}
