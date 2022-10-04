//
//  SettingsViewController.swift
//  Recipes
//
//  Created by Андрей Чернышев on 09.07.2022.
//

import UIKit
import RxSwift

final class SettingsViewController: UIViewController {
    lazy var mainView = SettingsView()
    
    private lazy var viewModel = SettingsViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AmplitudeManager.shared
            .logEvent(name: "Settings Screen")
        
        viewModel.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        mainView.tableView.mainDelegate = self
    }
}

// MARK: Make
extension SettingsViewController {
    static func make() -> SettingsViewController {
        let vc = SettingsViewController()
        vc.navigationItem.title = "Settings.Title".localized
        return vc
    }
}

// MARK: SettingsTableDelegate
extension SettingsViewController: SettingsTableDelegate {
    func settingsTableDidTappedContactUs() {
        guard let url = URL(string: GlobalDefinitions.contactUsUrl) else {
            return
        }
        
        UIApplication.shared.open(url, options: [:])
    }
    
    func settingsTableDidTappedPrivacyPolicy() {
        guard let url = URL(string: GlobalDefinitions.privacyPolicyUrl) else {
            return
        }
        
        UIApplication.shared.open(url, options: [:])
    }
    
    func settingsTableDidTappedTermsOfUse() {
        guard let url = URL(string: GlobalDefinitions.termsOfServiceUrl) else {
            return
        }
        
        UIApplication.shared.open(url, options: [:])
    }
    
    func settingsTableDidTappedGetAccess() {
        let vc = PaygateViewController.make()
        present(vc, animated: true)
    }
}
