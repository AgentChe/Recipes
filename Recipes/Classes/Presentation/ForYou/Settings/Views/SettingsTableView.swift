//
//  SettingsTableView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 09.07.2022.
//

import UIKit

protocol SettingsTableDelegate: AnyObject {
    func settingsTableDidTappedContactUs()
    func settingsTableDidTappedPrivacyPolicy()
    func settingsTableDidTappedTermsOfUse()
    func settingsTableDidTappedGetAccess()
}

final class SettingsTableView: UITableView {
    weak var mainDelegate: SettingsTableDelegate?
    
    private lazy var elements = [SettingsTableElement]()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SettingsTableView {
    func setup(elements: [SettingsTableElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension SettingsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .offset:
            let cell = dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self))!
            cell.backgroundColor = UIColor.clear
            cell.contentView.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            return cell
        case .contactUs(let element), .privacyPolicy(let element), .termsOfUser(let element):
            let cell = dequeueReusableCell(withIdentifier: String(describing: SettingsLinkCell.self)) as! SettingsLinkCell
            cell.setup(title: element)
            return cell
        case .separator:
            return dequeueReusableCell(withIdentifier: String(describing: SettingsSeparatorCell.self))!
        case .getAccess:
            return dequeueReusableCell(withIdentifier: String(describing: SettingsGetAccessCell.self))!
        }
    }
}

// MARK: UITableViewDelegate
extension SettingsTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch elements[indexPath.row] {
        case .offset(let offset):
            return offset
        case .contactUs, .privacyPolicy, .termsOfUser:
            return 21.scale
        case .separator:
            return 1.scale
        case .getAccess:
            return 168.scale
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch elements[indexPath.row] {
        case .contactUs:
            mainDelegate?.settingsTableDidTappedContactUs()
        case .privacyPolicy:
            mainDelegate?.settingsTableDidTappedPrivacyPolicy()
        case .termsOfUser:
            mainDelegate?.settingsTableDidTappedTermsOfUse()
        case .getAccess:
            mainDelegate?.settingsTableDidTappedGetAccess()
        default:
            break
        }
    }
}

// MARK: Private
private extension SettingsTableView {
    func initialize() {
        register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        register(SettingsLinkCell.self, forCellReuseIdentifier: String(describing: SettingsLinkCell.self))
        register(SettingsSeparatorCell.self, forCellReuseIdentifier: String(describing: SettingsSeparatorCell.self))
        register(SettingsGetAccessCell.self, forCellReuseIdentifier: String(describing: SettingsGetAccessCell.self))
        
        dataSource = self
        delegate = self
    }
}
