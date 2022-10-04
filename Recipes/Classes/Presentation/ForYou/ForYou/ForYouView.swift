//
//  ForYouView.swift
//  Recipes
//
//  Created by Андрей Чернышев on 07.07.2022.
//

import UIKit
import RxSwift

final class ForYouView: UIView {
    lazy var headerView = makeHeaderView()
    lazy var settingsButton = makeSettingsButton()
    lazy var titleLabel = makeTitleLabel()
    lazy var tableView = makeTableView()
    lazy var preloader = makePreloader()
    
    private lazy var headerHeightConstraint = NSLayoutConstraint()
    
    private lazy var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension ForYouView {
    func initialize() {
        backgroundColor = Appearance.background
        
        tableView.rx.contentOffset
            .bind(to: Binder(self) { base, offset in
                let max = ScreenSize.isIphoneXFamily ? 354.scale : 324.scale
                let min = ScreenSize.isIphoneXFamily ? 135.scale : 105.scale
                let bias = (max - offset.y - base.tableView.contentInset.top)
                let height = bias < min ? min : (bias > max ? max : bias)
                base.headerHeightConstraint.constant = height
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make constraints
private extension ForYouView {
    func makeConstraints() {
        headerHeightConstraint = headerView.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 354.scale : 324)
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerHeightConstraint
        ])
        
        NSLayoutConstraint.activate([
            settingsButton.widthAnchor.constraint(equalToConstant: 24.scale),
            settingsButton.heightAnchor.constraint(equalToConstant: 24.scale),
            settingsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -19.scale),
            settingsButton.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 54.scale : 34.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 91.scale : 61.scale)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloader.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ForYouView {
    func makeHeaderView() -> UIView {
        let view = UIView()
        view.backgroundColor = Appearance.primaryYellow
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
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.black)
            .font(Fonts.PlusJakartaSans.extraBold(size: 34.scale))
            .lineHeight(40.8.scale)
            .letterSpacing(-1.scale)
        
        let view = UILabel()
        view.attributedText = "ForYou.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTableView() -> ForYouTableView {
        let view = ForYouTableView()
        view.contentInset = UIEdgeInsets(top: 28.scale, left: 0, bottom: 28.scale, right: 0)
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> Spinner {
        let view = Spinner(size: CGSize(width: 45.scale, height: 45.scale))
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
